$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'attributarchy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'attributarchy'
  s.version     = Attributarchy::VERSION
  s.authors     = ['Chris Canipe']
  s.email       = ['chris.canipe+attributarchy@gmail.com']
  s.homepage    = 'https://github.com/epicyclist/attributarchy'
  s.description = 'An attribute-driven hierarchy builder for Rails views.'
  s.summary     = s.description

  s.files = Dir["{app,config,db,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency 'rails', '~> 3.2.14'
  s.add_development_dependency 'rspec-rails', '~> 2.14.0'
  s.add_development_dependency 'fakefs', '~> 0.4.2'
  # Nokogiri was... difficult. Thanks to @Tekhne for this one:
  #
  #   Mac OS X 10.7 appears to load its own version of libxml2 (and dependencies)
  #   at boot time. Unfortunately, if you compile nokogiri against your own version
  #   of libxml2 (and dependencies, e.g. via Homebrew), the compilation will work,
  #   but OS X will force nokogiri to load the system library (and dependencies).
  #   This will result in a warning every time nokogiri is used. The solution is to
  #   tell Bundler to build nokogiri against the system library (and dependencies):
  #
  #   bundle conf build.nokogiri bundle conf build.nokogiri \
  #      --with-xml2-dir=/usr \
  #      --with-xslt-dir=/usr \
  #      --with-iconv-dir=/usr
  s.add_development_dependency 'rspec-html-matchers', '~> 0.4.3'

end
