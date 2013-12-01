define ["./object2d"], (Object2d) ->
  class Scene extends Object2d
    constructor: (options={}) ->
      options.name ?= "Scene"
      super options
