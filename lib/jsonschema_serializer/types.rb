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

      class << self
        # Default Hash structure. This should be implemented in
        # every subclass
        def default_hash
          {}
        end

        def empty(**opts)
          new
            .yield_self { |h| h.merge(default_hash) }
            .merge(opts)
        end

        def named(name, **opts)
          new
            .yield_self do |h|
              h.merge(name => empty(**opts))
            end
        end
      end
    end

    # Object type for jsonschema serializer
    class Object < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :object, properties: {} }
        end
        # initialize a empty object
      end
    end

    # Number type for jsonschema serializer
    class Number < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :number }
        end
      end
    end

    # Integer type for jsonschema serializer
    class Integer < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :integer }
        end
      end
    end
  end
end
