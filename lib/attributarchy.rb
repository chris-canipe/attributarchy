require 'attributarchy/controller_methods'

module Attributarchy
  extend ActiveSupport::Concern
  included do
    include Attributarchy::ControllerMethods
  end
end
