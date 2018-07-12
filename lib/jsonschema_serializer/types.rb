# frozen_string_literal: true

require 'json'

module JsonschemaSerializer
  # +Hash+ class with some extended methods
  class FutureHash < Hash
    # Backport ruby 2.5 yield_self method
    def yield_self
      yield(self)
    end

    # The +to_json+ method exports the schema as a json string
    # By default it would exported with a pretty print
    #
    # Params:
    # +pretty+:: +Boolean+

    def to_json(pretty: true)
      pretty ? JSON.pretty_generate(self.dup) : super
    end
  end

  # This module contains types declarations
  module Types
    # Base type from which all other types inherit
    class Base < JsonschemaSerializer::FutureHash
      class << self
        # Default FutureHash structure. This should be implemented in
        # every subclass
        def default_hash
          FutureHash.new
        end

        # Default Hash structure merged with class attributes and instance options
        def processed_hash(**opts)
          default_hash
            .yield_self { |h| class_attributes.reduce(h) { |h1, a| h1.merge(a) } }
            .merge(opts)
        end

        # Initialize a new object with the default hash attributes
        def new(**opts)
          super.yield_self do |h|
            if !@name.nil?
              # Merge with name and reset it after the creation
              h.merge(@name => processed_hash(**opts)).tap { @name = nil }
            else
              h.merge(processed_hash(**opts))
            end
          end
        end

        # Initialize a new object with name as key
        def named(name, **opts)
          @name = name
          new(**opts)
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
          FutureHash[{ type: :array }]
        end

        # Default new array
        #
        # Params:
        # +items+:: an object representation or an array of objects
        #

        def new(items:, **opts)
          super(items: items, **opts)
        end
      end
    end

    # Boolean type for jsonschema serializer
    class Boolean < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          FutureHash[{ type: :boolean }]
        end
      end
    end

    # Integer type for jsonschema serializer
    class Integer < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          FutureHash[{ type: :integer }]
        end
      end
    end

    # Number type for jsonschema serializer
    class Number < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          FutureHash[{ type: :number }]
        end
      end
    end

    # Object type for jsonschema serializer
    class Object < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          FutureHash[{ type: :object, properties: {} }]
        end
      end
    end

    # String type for jsonschema serializer
    class String < JsonschemaSerializer::Types::Base
      class << self
        # Default Hash structure
        def default_hash
          FutureHash[{ type: :string }]
        end
      end
    end
  end
end
