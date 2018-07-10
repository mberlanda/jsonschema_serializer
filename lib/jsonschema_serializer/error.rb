# frozen_string_literal: true

module JsonschemaSerializer
  # +AllowedExcludedError+ is an +ArgumentError+
  class AllowedExcludedError < ArgumentError
    # Default message for +AllowedExcludedError+ instance
    DEFAULT_MESSAGE = 'You cannot provide both allowed and excluded attributes'

    def initialize(msg = DEFAULT_MESSAGE)
      super(msg)
    end
  end

  # +DuplicatedObjectPropertyError+ is an +ArgumentError+
  class DuplicatedObjectPropertyError < ArgumentError
    # Default message for +DuplicatedObjectPropertyError+ instance
    DEFAULT_MESSAGE = 'Duplicated declaration for object properties'

    def initialize(msg = DEFAULT_MESSAGE)
      super(msg)
    end
  end
end
