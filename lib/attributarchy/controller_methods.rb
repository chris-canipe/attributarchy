module Attributarchy
  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :attributarchy_configuration
    end

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
      lookup_paths = lookup_prefixes.map do |prefix|
        File.join(::Rails.root, %w[app views], prefix)
      end
      prepend_view_path(lookup_paths)
      ### Check partial existence.
      attributes.each do |a|
        raise MissingPartial unless partial_exists_for?(a)
      end
      ### Set configuration
      self.attributarchy_configuration ||= {}
      self.attributarchy_configuration[name] = attributes
    end

    def partial_exists_for?(attribute)
      lookup_context.exists?(attribute.to_s, [], true)
    end

  end

end
