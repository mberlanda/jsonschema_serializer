require "json"

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
  end
end
