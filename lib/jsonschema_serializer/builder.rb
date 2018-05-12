require 'json'

module JsonschemaSerializer
  class Builder
    class << self
      def build
        new.tap do |builder|
          yield(builder) if block_given?
        end
      end
    end

    attr_reader :schema

    def initialize
      @schema ||= {
        type: :object,
        properties: {}
      }
    end

    def to_json
      @schema.to_json
    end

    def title(title)
      @schema[:title] = title
    end

    def description(description)
      @schema[:description] = description
    end

    def required(*required)
      @schema[:required] = required
    end

    def properties
      @schema[:properties] ||= {}
    end

    [:boolean, :integer, :number, :string].each do |attr_type|
      define_method(attr_type) do |name, **opts|
        {
          name => { type: attr_type }.merge(opts)
        }
      end
    end
  end
end
