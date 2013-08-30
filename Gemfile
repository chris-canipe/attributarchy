source "https://rubygems.org"

# Declare your gem's dependencies in attributarchy.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'pry-debugger'
end

group :test do
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
  gem 'rspec-html-matchers'
end
