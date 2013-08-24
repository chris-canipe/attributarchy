module Attributarchy
  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :attributarchy_configuration
    end

    # TODO: Expand to allow multiple named attributarchies at some point.
    def has_attributarchy(attributes)
      ### Check attribute configuration.
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

      self.attributarchy_configuration = {
        attributes: attributes,
        partial_directory: partial_directory
      }
    end

    def partial_directory
      "#{controller_name}/attributarchy"
    end

    def partial_directory_path
      # TODO: Search all?
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
