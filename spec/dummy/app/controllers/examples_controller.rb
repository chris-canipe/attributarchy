class ExamplesController < ApplicationController
  include Attributarchy
  ContinentCountry = Struct.new(:continent, :country)
  has_attributarchy :continents_and_countries, as: [:continent, :country]
  def index
    @continents_and_countries = [
      ContinentCountry.new('North America', 'Canada'),
      ContinentCountry.new('North America', 'USA'),
      ContinentCountry.new('North America', 'Mexico'),
      ContinentCountry.new('South America', 'Argentina'),
      ContinentCountry.new('South America', 'Bolivia'),
      ContinentCountry.new('South America', 'Brazil')
    ]
  end
end
