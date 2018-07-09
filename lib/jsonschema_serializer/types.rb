# frozen_string_literal: true

module JsonschemaSerializer
  # This module contains types declarations
  module Types
    # Base type from which all other types inherit
    class Base < Hash
      # Backport ruby 2.5 yield_self method
      def yield_self
        yield(self)
      end
    end

    # Object type for jsonschema serializer
    class Object < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        DEFAULT_HASH = {
          type: :object, properties: {}
        }.freeze
        # initialize a empty object
        def empty(**opts)
          new
            .yield_self { |h| h.merge(DEFAULT_HASH) }
            .merge(opts)
        end
      end
    end
  end
end
