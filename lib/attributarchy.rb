require 'attributarchy/exceptions'
require 'attributarchy/controller_methods'
require 'attributarchy/helpers'

module Attributarchy
  extend ActiveSupport::Concern
  included do
    include Attributarchy::ControllerMethods
    include Attributarchy::Helpers
  end
end
