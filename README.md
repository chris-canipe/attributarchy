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
    # Required:
      # Name it, as you can define multiple
      :name,
      # Specify an array of attributes that constitute the (?:attribut|hier)archy
      as: [:attribute, ...],
    # Optional:
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


## TODO

1. Allow configuration of the wrapping element and class.
