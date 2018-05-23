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
          b.title schema_title(klass)
          selected_columns(klass, only, except).each do |col|
            b.properties.tap do |prop|
              el = format_column_element(col)
              # Handle basic case of attribute type and attribute name
              prop.merge! b.send(el[:type], el[:name])
            end
          end
        end
      end

      # Raise if +only+ and +except+ are both provided
      #
      # Params:
      # +only+:: +Array+ columns as +String+
      # +except+:: +Array+ columns as +String+

      def validate_arguments(only, except)
        raise ArgumentError, 'only and except options both provided' if only && except
      end

      # Extract schema title from ActiveRecord class
      # This method can be overridden when inheriting from this class
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name

      def schema_title(klass)
        klass.model_name.human
      end

      # Retrieves the columns and keep/discard some elements if needed
      #
      # Params:
      # +klass+:: +ActiveRecord::Base+ class name
      # +only+:: +Array+ columns as +String+
      # +except+:: +Array+ columns as +String+

      def selected_columns(klass, only, except)
        klass.columns.dup.tap do |cols|
          cols.select! { |col| only.include?(col.name) } if only
          cols.reject! { |col| except.include?(col.name) } if except
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
        text: :string
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
        col.sql_type_metadata.type
      end
    end
  end
end
