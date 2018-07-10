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

        # Initialize an empty object with the default hash attributes
        def empty(**opts)
          new
            .yield_self { |h| h.merge(default_hash) }
            .yield_self { |h| class_attributes.reduce(h) { |h1, a| h1.merge(a) } }
            .merge(opts)
        end

        # Initialize an empty object with name as key
        def named(name, **opts)
          new
            .yield_self do |h|
              h.merge(name => empty(**opts))
            end
        end

        # Allowed class attributes declaration
        def allowed_class_attributes
          [@title, @description, @default]
        end

        # Class level attributes declaration
        def class_attributes
          allowed_class_attributes.compact
        end

        # Assigns the +default+ to the object
        #
        # Params:
        # +default+:: default value field of the object

        def default(default_value)
          @default = { default: default_value }
        end

        # Assigns the +description+ to the object
        #
        # Params:
        # +description+:: +String+ or +Symbol+ description field of the object

        def description(description)
          @description = { description: description }
        end

        # Assigns the +title+ to the object
        #
        # Params:
        # +title+:: +String+ or +Symbol+ title field of the object

        def title(title)
          @title = { title: title }
        end
      end
    end

    # Array type for jsonschema serializer
    class Array < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :array }
        end

        # Default empty array
        #
        # Params:
        # +items+:: an object representation or an array of objects
        #

        def empty(items:, **opts)
          super(**opts)
            .yield_self { |h| h.merge(items: items) }
        end
      end
    end

    # Boolean type for jsonschema serializer
    class Boolean < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :boolean }
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

    # Number type for jsonschema serializer
    class Number < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :number }
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
      end
    end

    # String type for jsonschema serializer
    class String < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          { type: :string }
        end
      end
    end
  end
end
