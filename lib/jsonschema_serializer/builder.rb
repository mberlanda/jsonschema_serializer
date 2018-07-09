# frozen_string_literal: true

require 'json'
require_relative 'types'

module JsonschemaSerializer
  # The +JsonschemaSerializer::Builder+ class provides
  # an effective DSL to generate a valid json schema.
  class Builder
    class << self
      # The +build+ class method create a new instance and applies the block
      def build
        new.tap do |builder|
          yield(builder) if block_given?
        end
      end
    end

    # An hash representation of the +schema+
    attr_reader :schema

    # The +new+ method creates assigns an empty object
    # to a +schema+ instance variable
    def initialize
      @schema ||= _object
    end

    # The +to_json+ method exports the schema as a json string
    # By default it would exported with a pretty print
    #
    # Params:
    # +pretty+:: +Boolean+

    def to_json(pretty: true)
      pretty ? JSON.pretty_generate(@schema) : @schema.to_json
    end

    # Assigns the +title+ to the root schema object
    #
    # Params:
    # +title+:: +String+ or +Symbol+ title field of the schema object

    def title(title)
      @schema[:title] = title
    end

    # Assigns the +description+ to the root schema object
    #
    # params:
    # +description+:: +String+ description field of the schema object

    def description(description)
      @schema[:description] = description
    end

    # The +required+ method allows to provide a list of required properties
    #
    # params:
    # +required+ [Array[String, Symbol]]

    def required(*required)
      @schema[:required] = required
    end

    # The +properties+ method allows to access object properties
    #
    # e.g.:
    #   JsonschemaSerializer::Builder.build do |b|
    #     b.properties.tap do |p|
    #       p.merge! {}
    #     end
    #   end

    def properties
      @schema[:properties] ||= {}
    end

    # A base representation of the +boolean+ type.
    def _boolean(**opts)
      { type: :boolean }.merge(opts)
    end

    # A property representation of the +boolean+ type.
    #
    # Params:
    # +name+:: +String+ or +Symbol+
    #
    # Optional Params:
    # +default+:: +Boolean+ default value
    # +description+:: +String+ property description
    # +title+:: +String+ property title

    def boolean(name, **opts)
      { name => _boolean(opts) }
    end

    # A base representation of the +integer+ type.
    def _integer(**opts)
      { type: :integer }.merge(opts)
    end

    # A property representation of the +integer+ type.
    #
    # Params:
    # +name+:: +String+ or +Symbol+
    #
    # Optional Params:
    # +default+:: +Integer+ default value
    # +description+:: +String+ property description
    # +title+:: +String+ property title
    # +enum+:: +Array+ property allowed values
    # +minimum+:: +Integer+ property minimum value
    # +maximum+:: +Integer+ property maximum value
    # +multipleOf+:: +Integer+ property conditional constraint

    def integer(name, **opts)
      { name => _integer(opts) }
    end

    # A base representation of the +number+ type.
    def _number(**opts)
      { type: :number }.merge(opts)
    end

    # A property representation of the +number+ type.
    #
    # Params:
    # +name+:: +String+ or +Symbol+
    #
    # Optional Params:
    # +default+:: +Numeric+ default value
    # +description+:: +String+ property description
    # +title+:: +String+ property title
    # +enum+:: +Array+ property allowed values
    # +minimum+:: +Numeric+ property minimum value
    # +maximum+:: +Numeric+ property maximum value
    # +multipleOf+:: +Numeric+ property conditional constraint

    def number(name, **opts)
      { name => _number(opts) }
    end

    # A base representation of the +string+ type.
    def _string(**opts)
      { type: :string }.merge(opts)
    end

    # A property representation of the +string+ type.
    #
    # Params:
    # +name+:: +String+ or +Symbol+
    #
    # Optional Params:
    # +default+:: +String+ default value
    # +description+:: +String+ property description
    # +title+:: +String+ property title
    # +format+:: +String+ property format for validation
    # +minLength+:: +Int+ property minimum length

    def string(name, **opts)
      { name => _string(opts) }
    end

    # A base representation of the +object+ type.
    #
    #   JsonschemaSerializer::Builder.build do |b|
    #     subscriber = b._object title: :subscriber, required: [:age] do |prop|
    #       prop.merge! b.string :first_name, title: 'First Name'
    #       prop.merge! b.string :last_name, title: 'Last Name'
    #       prop.merge! b.integer :age, title: 'Age'
    #     end
    #   end

    def _object(**opts)
      JsonschemaSerializer::Types::Object.empty(opts).tap do |h|
        yield(h[:properties]) if block_given?
      end
    end

    # A property representation of the +array+ type.
    #
    # Params:
    # +name+:: +String+ or +Symbol+
    # +items+:: an object representation or an array of objects
    #
    # Optional Params:
    # +default+:: +Array+ default value
    # +description+:: +String+ property description
    # +title+:: +String+ property title
    # +minItems+:: +Int+ property minimum length
    # +maxItems+:: +Int+ property maximum length
    #
    #   JsonschemaSerializer::Builder.build do |b|
    #     b.array :integers, items: {type: :integer}, minItems:5
    #     b.array :strings, items: b._string, default: []
    #
    #     subscriber = b._object title: :subscriber, required: [:age] do |prop|
    #       prop.merge! b.string :first_name, title: 'First Name'
    #       prop.merge! b.string :last_name, title: 'Last Name'
    #       prop.merge! b.integer :age, title: 'Age'
    #     end
    #     b.array :subscribers, items: subscriber
    #   end

    def array(name, items:, **opts)
      {
        name => { type: :array, items: items }.merge(opts)
      }
    end
  end
end
