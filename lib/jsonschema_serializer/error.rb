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
end
