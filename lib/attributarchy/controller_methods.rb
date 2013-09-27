module Attributarchy
  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :attributarchy_configuration
      helper_method :build_attributarchy
      helper_method :attributarchy_configuration
    end

    def attributarchy_configuration
      self.attributarchy_configuration
    end

    module ClassMethods
      def has_attributarchy(name, arguments = {})
        ### Check attribute configuration.
        raise ArgumentErorr, 'No attributarchy specified' \
          unless arguments.is_a?(Hash) && arguments.has_key?(:as)
        attributes = arguments[:as]
        raise ArgumentError, 'Expecting attributarchy (an array of symbols representing attributes)' \
          unless attributes.is_a? Array
        raise ArgumentError, 'Attributarchy cannot be empty' \
          if attributes.empty?
        raise ArgumentError, 'Attributarchy should be specified using symbols' \
          unless attributes.all? { |a| a.is_a? Symbol }
        ### Lookup prefixes (optional). Always include controller.
        lookup_prefixes = [controller_name]
        if arguments.has_key?(:in)
          additional_lookup_prefixes = arguments[:in]
          raise ArgumentError, 'Lookup prefixes must be specified as a string or array' \
            unless [Array, String].any? { |type| additional_lookup_prefixes.is_a?(type) }
          lookup_prefixes << additional_lookup_prefixes
        end
        lookup_prefixes.flatten!
        prepend_view_path(lookup_prefixes)
        ### Group-only attributes that do not render (optional).
        without_rendering = {}
        if arguments.has_key?(:without_rendering)
          without_rendering = arguments[:without_rendering]
          raise ArgumentError, ':without_rendering must be specified as a symbol or array' \
            unless [Array, Symbol].any? { |type| without_rendering.is_a?(type) }
          without_rendering = Hash[*[without_rendering].flatten.map { |k| [k, nil] }.flatten]
        end
        ### Set configuration
        self.attributarchy_configuration ||= {}
        self.attributarchy_configuration[name] = attributes
        self.attributarchy_configuration[:without_rendering] = without_rendering
      end
    end

  end

end
