# frozen_string_literal: true

require_relative 'error'

module JsonschemaSerializer
  # Module containing utilities functions for filtering
  module FilterUtilities
    # Method to include the ClassMethods submodule
    def self.included(base)
      base.extend(ClassMethods)
    end

    # ClassMethods
    module ClassMethods
      # When defining a sub class, declare which attributes
      # should be allowed.
      #
      # Params:
      # +list+:: +Array+ columns as +Symbol+

      def allowed_attributes(*list)
        raise AllowedExcludedError unless excluded_obj_attributes.empty?
        allowed_obj_attributes.concat(list.map(&:to_s))
      end

      # When defining a sub class, declare which attributes
      # should be excluded.
      #
      # Params:
      # +list+:: +Array+ columns as +Symbol+

      def excluded_attributes(*list)
        raise AllowedExcludedError unless allowed_obj_attributes.empty?
        excluded_obj_attributes.concat(list.map(&:to_s))
      end

      # Store allowed attributes for a given object/class
      # These can be set in several times

      def allowed_obj_attributes
        @allowed_obj_attributes ||= []
      end

      # Store excluded attributes for a given object/class
      # These can be set in several times

      def excluded_obj_attributes
        @excluded_obj_attributes ||= []
      end
    end
  end
end
