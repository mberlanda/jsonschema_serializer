# frozen_string_literal: true

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
      # +only+:: +Array+ columns as +Symbol+

      def allowed_attributes(*list)
        allowed_obj_attributes.concat(list.map(&:to_s))
      end

      # Store allowed attributes for a given object/class
      # These can be set in several times

      def allowed_obj_attributes
        @allowed_obj_attributes ||= []
      end
    end
  end
end
