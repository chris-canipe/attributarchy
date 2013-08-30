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
      ### Check partial configuration.
      # Directory
      raise MissingDirectory, "Attributarchy partial directory is missing; expecting #{partial_directory}" \
        unless partial_directory_exists?
      # Partials
      attributes.each do |a|
        raise MissingPartial unless partial_exists?(a)
      end

      self.attributarchy_configuration ||= {
        partial_directory: partial_directory
      }
      self.attributarchy_configuration[name] = attributes
    end

    def partial_directory
      "#{controller_name}/attributarchy"
    end

    def partial_directory_path
      "#{view_context.view_paths.first}/#{partial_directory}"

    end

    def partial_directory_exists?
      File.directory?(partial_directory_path)
    end

    def partial_exists?(partial)
      lookup_context.template_exists?(partial.to_s, [partial_directory], true)
    end

  end

end
