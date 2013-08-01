module Attributarchy
  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :attributarchy_configuration
    end

    # TODO: Expand to allow multiple named attributarchies at some point.
    def has_attributarchy(attributes)
      # Check attribute configuration.
      raise ArgumentError, 'Expecting attributarchy (an array of symbols representing attributes)' \
        unless attributes.is_a? Array
      raise ArgumentError, 'Attributarchy cannot be empty' \
        if attributes.empty?
      raise ArgumentError, 'Attributarchy should be specified using symbols' \
        unless attributes.all? { |a| a.is_a? Symbol }
      # Check partial configuration.
      partial_directory = "#{view_context.view_paths.first}/#{controller_name}/attributarchy/"
      raise MissingDirectory, "Attributarchy partial directory is missing; expecting #{partial_directory}" \
        unless File.directory?(partial_directory)

      self.attributarchy_configuration = attributes
    end

  end

end
