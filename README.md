[![Version](http://allthebadges.io/epicyclist/attributarchy/badge_fury.png)](http://allthebadges.io/epicyclist/attributarchy/badge_fury)
[![Dependency Status](https://gemnasium.com/epicyclist/attributarchy.png)](https://gemnasium.com/epicyclist/attributarchy)
[![Build Status](http://allthebadges.io/epicyclist/attributarchy/travis.png)](http://allthebadges.io/epicyclist/attributarchy/travis)
[![Coverage](http://allthebadges.io/epicyclist/attributarchy/coveralls.png)](http://allthebadges.io/epicyclist/attributarchy/coveralls)
[![Code Climate](http://allthebadges.io/epicyclist/attributarchy/code_climate.png)](http://allthebadges.io/epicyclist/attributarchy/code_climate)


# Attributarchy

An attribute-driven hierarchy builder for Rails views.

## The Idea

**You do this:**

1. Configure a hierarchy (or hierarchies) of attributes
1. Create partials for each attribute
1. Feed this duo some data

**And you get this:**

Dynamic, hierarchical views that allow you to easily dish out an array of layouts, styles, and behavior. All as simple or complex as you'd like.

## Usage

##### In your Gemfile:

```ruby
  gem 'attributarchy'
```

##### In your controller:

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

##### In your controller's corresponding view directory (or another location configured via :in):

Define a partial for all rendering attributes. The locals provided to these are:

1. *group_data* -- The data set of the grouped-by attribute
1. *group_value* -- The name of the grouped-by attribute
1. *group_level* -- An integer representing the position of the grouping within the hierarchy

##### And, finally, in your view:

```ruby
  build_attributarchy(:name, data_set)
```

## Working With Engines

My knowledge is limited here, but to get this working in an engine you must specify a full lookup path, e.g.:
````ruby
  in: "#{YourEngine::Engine.root}/app/views/your_engine/..."
````

I believe this is the only way to do this short of converting the gem to a rail tie, but I'm not positive. Besides, I don't want Attributarchy included in *every* controller anyway &mdash; it seems quite specialized.

## Examples

To see a simple example, start the dummy rails app and hit its root.
