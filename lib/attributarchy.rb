module Attributarchy
  extend ActiveSupport::Concern

  included do
    class_attribute :attributarchy_configuration
  end

  # TODO: Expand to allow multiple named attributarchies at some point.
  def has_attributarchy(attributes)
    raise 'Expecting attributarchy (an array of symbols representing attributes)' \
      unless attributes.is_a? Array
    raise 'Attributarchy cannot be empty' \
      if attributes.empty?
    raise 'Attributes should be specified as symbols' \
      unless attributes.all? { |a| a.is_a? Symbol }
    self.attributarchy_configuration = attributes
  end

end
