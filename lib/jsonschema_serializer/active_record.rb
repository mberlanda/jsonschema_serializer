require_relative 'builder'

module JsonschemaSerializer
  # The +JsonschemaSerializer::Activerecord+ module provides
  # a +from_activerecord+ class method  to serialize some
  # ActiveRecord classes with the minimum effort
  module ActiveRecord
    def self.included(klass) # :nodoc:
      klass.extend(ClassMethods)
    end

    module ClassMethods # :nodoc:
      # Serialize an ActiveRecord class into a
      # JsonschemaSerializer::Builder object
      #
      # params:
      # +klass+ [ActiveRecord::Base]
      # +only+ [Array[String]]
      # +except+ [Array[String]]
      def from_active_record(klass, only: nil, except: nil)
        validate_arguments(only, except)
        JsonschemaSerializer::Builder.build do |b|
          selected_columns(klass, only, except).each do |col|
            b.properties.tap do |prop|
              el = format_column_element(col)
              # Handle basic case of attribute type and attribute name
              prop.merge! b.send(el[:type], el[:name])
            end
          end
        end
      end

      private

      # Raise if +only+ and +except+ are both provided
      def validate_arguments(only, except)
        raise ArgumentError, 'only and except options both provided' if only && except
      end

      # Retrieves the columns and keep/discard some elements if needed
      def selected_columns(klass, only, except)
        klass.columns.tap do |cols|
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
      def format_column_element(col)
        {}.tap do |h|
          h[:name] = col.name
          h[:type] = TYPE_CONVERSIONS[col.type] || :string
          # col.default.tap { |d| h[:default] = d if d}
        end
      end
    end
  end
end
