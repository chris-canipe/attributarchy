# Attributarchy

An attribute-driven hierarchy builder for Rails views.

## The Idea

**You do this:**

1. Configure a hierarchy (or hierarchies) of attributes
1. Create partials for each attribute
1. Feed this duo some data

**And you get this:**

Dynamic, hierarchical views that allow you to easily dish out an array of layouts, styles, and behavior. All as simple or complex as you'd like.

## TODO

1. Allow the partial directory to be configured, e.g., specify a shared directory
   that is not tied to controller's view paths.
1. Search all view paths -- not just the first.
1. Allow an attributarchy to be defined without an accompanying partial, i.e.,
   it's for grouping only -- there's nothing to display.
1. Allow configuration of the wrapping element and class.
