[![Gem Version](https://badge.fury.io/rb/attributarchy.png)](http://badge.fury.io/rb/attributarchy)
[![Dependency Status](https://gemnasium.com/epicyclist/attributarchy.png)](https://gemnasium.com/epicyclist/attributarchy)
[![Build Status](https://travis-ci.org/epicyclist/attributarchy.png?branch=master)](https://travis-ci.org/epicyclist/attributarchy)
[![Coverage Status](https://coveralls.io/repos/epicyclist/attributarchy/badge.png)](https://coveralls.io/r/epicyclist/attributarchy)
[![Code Climate](http://allthebadges.io/epicyclist/attributarchy/code_climate.png)](http://allthebadges.io/epicyclist/attributarchy/code_climate)


# Attributarchy

An attribute-driven hierarchy builder for Rails views.

## The Gist

1. Configure a hierarchy (or hierarchies) of attributes
1. Create partials for each attribute that you want to render
1. Style and/or bind JavaScript as desired
1. Feed the attributarchy some data

**The result:** Dynamic, hierarchical views that allow you to easily dish out an array of layouts, styles, and behavior. All as simple or complex as you'd like.

## Usage

#### Gemfile

```ruby
  gem 'attributarchy'
```

#### Controller [(example)](https://github.com/epicyclist/attributarchy/blob/master/spec/dummy/app/controllers/examples_controller.rb)

```ruby
  include Attributarchy

  has_attributarchy \
    #----------#
    # Required #
    #----------#
      # Name it, as you can define multiple
      :name,
      # Specify an array of attributes that constitute the (?:attribut|hier)archy
      as: [:attribute, ...],
    #----------#
    # Optional #
    #----------#
      # Specify an additional lookup path (as a string) or paths (as an array)
      in: %w[this_path that_path],
      # Specify an attribute (as a symbol) or attributes (as an array) that will
      # only be used for grouping -- not rendering
      without_rendering: [:a_no_show]
```

#### Partials [(example)](https://github.com/epicyclist/attributarchy/tree/master/spec/dummy/app/views/examples)

In your controller's view directory (or another location configured via ``:in``), define a partial for all rendering attributes. The locals provided to these are:

- ``group_data`` &mdash; The data set of the grouped-by attribute
- ``group_value`` &mdash; The name of the grouped-by attribute
- ``group_level`` &mdash; An integer representing the position of the grouping within the hierarchy

#### View [(example)](https://github.com/epicyclist/attributarchy/blob/master/spec/dummy/app/views/examples/index.html.erb)

```ruby
  build_attributarchy(:name, data_set)
```

#### Assets [(example)](https://github.com/epicyclist/attributarchy/blob/master/spec/dummy/app/assets/stylesheets/application.css)

The entire attributarchy will be wrapped in a ``div`` with the class "attributarchy" and each attributarchy will we wrapped in a ``div`` with the class of "*attribute*-attributarchy".

## Working With Engines

My knowledge is limited here, but to get this working in an engine you must specify a full lookup path, e.g.:
````ruby
  in: "#{YourEngine::Engine.root}/app/views/your_engine/..."
````

I believe this is the only way to do this short of converting the gem to a rail tie, but I'm not positive. Besides, I don't want Attributarchy included in *every* controller anyway &mdash; it seems quite specialized.

## Examples

To see a simple example, start the dummy rails app and hit its root.
