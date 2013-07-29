$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'attributarchy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'attributarchy'
  s.version     = Attributarchy::VERSION
  s.authors     = ['Chris Canipe']
  s.email       = ['chris.canipe+attributarchy@gmail.com']
  s.homepage    = 'TODO'
  s.description = 'An attribute-driven hierarchy builder for Rails views.'
  s.summary     = s.description

  s.files = Dir["{app,config,db,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 3.2.14'
  s.add_dependency 'rspec-rails', '~> 2.14.0'
end
