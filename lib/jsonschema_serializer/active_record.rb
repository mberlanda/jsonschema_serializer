# frozen_string_literal: true

require_relative 'builder'

module JsonschemaSerializer
  # The +JsonschemaSerializer::ActiveRecord+ class provides
  # a +from_model+ class method to serialize some
  # ActiveRecord classes with the minimum effort
  class ActiveRecord
    class << self
      # Serialize an ActiveRecord class into a
      # JsonschemaSerializer::Builder object
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name
      # +only+:: +Array+ columns as +String+
      # +except+:: +Array+ columns as +String+

      def from_model(klass, only: nil, except: nil)
        validate_arguments(only, except)
        JsonschemaSerializer::Builder.build do |b|
          format_schema_attributes(klass, b)
          format_schema_properties(selected_columns(klass), b)
        end
      end

      # Raise if +only+ and +except+ are both provided
      #
      # Params:
      # +only+:: +Array+ columns as +String+
      # +except+:: +Array+ columns as +String+

      def validate_arguments(only, except)
        raise ArgumentError, 'only and except options both provided' if only && except
        @only = only
        @except = except
      end

      # Format JsonSchema general attributes such as title, required
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name
      # +builder+:: +JsonschemaSerializer::Builder+ an instance of the builder

      def format_schema_attributes(klass, builder)
        builder.title schema_title(klass)
        required(klass).tap do |required|
          builder.required(*required) unless required.empty?
        end
      end

      # Format JsonSchema properties
      #
      # Params:
      # +columns+:: +Array+ array of formatted
      # +builder+:: +JsonschemaSerializer::Builder+ an instance of the builder

      def format_schema_properties(columns, builder)
        builder.properties.tap do |prop|
          columns.each do |col|
            el = format_column_element(col)
            # Handle basic case of attribute type and attribute name
            prop.merge! builder.send(el[:type], el[:name])
          end
        end
      end

      # Extract schema title from ActiveRecord class
      # This method can be overridden when inheriting from this class
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name

      def schema_title(klass)
        klass.model_name.human
      end

      # Filter required ActiveRecord class implementation with only/except
      #
      # Params:
      # +columns+:: +Array+ column names as +Symbol+

      # Filter required class attributes with only/filters attributes
      # This method can be overridden when inheriting from this class
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name

      def required(klass)
        required_from_class(klass).tap do |req|
          return req & @only if @only
          return req - @except if @except
        end
      end

      # Extract required attributes from ActiveRecord class implementation
      # This method can be overridden when inheriting from this class
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name

      def required_from_class(klass)
        klass.validators.select do |validator|
          validator.class.to_s == 'ActiveRecord::Validations::PresenceValidator'
        end.map(&:attributes).flatten
      end

      # Retrieves the columns and keep/discard some elements if needed
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name
      # +only+:: +Array+ columns as +String+
      # +except+:: +Array+ columns as +String+

      def selected_columns(klass)
        klass.columns.dup.tap do |cols|
          cols.select! { |col| @only.include?(col.name) } if @only
          cols.reject! { |col| @except.include?(col.name) } if @except
        end
      end

      # Mapping Ruby types on Jsonschema types.
      # This could be moved to a separate module later

      TYPE_CONVERSIONS = {
        boolean: :boolean,
        datetime: :string,
        decimal: :number,
        float: :number,
        integer: :integer,
        text: :string,
        varchar: :string
      }.freeze

      # Format a ActiveRecord::ConnectionAdapters::<Adapter>::Column as an Hash
      #
      # Params:
      # +klass+:: +ActiveRecord::ConnectionAdapters::<Adapter>::Column+ column

      def format_column_element(col)
        {}.tap do |h|
          h[:name] = col.name
          h[:type] = TYPE_CONVERSIONS[sql_type(col)] || :string
          # col.default.tap { |d| h[:default] = d if d}
        end
      end

      # Retrieves type from ActiveRecord::ConnectionAdapters::SqlTypeMetadata
      #
      # Params:
      # +col+:: +ActiveRecord::ConnectionAdapters::<Adapter>::Column+ column

      def sql_type(col)
        return col.sql_type_metadata.type if col.respond_to?(:sql_type_metadata)
        # Rails 4 backward compatibility
        col.sql_type.downcase.to_sym
      end
    end
  end
end
