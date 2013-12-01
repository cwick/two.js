define ["./object2d", "./scene_material"], (Object2d, SceneMaterial) ->
  class Scene extends Object2d
    constructor: (options={}) ->
      options.name ?= "Scene"
      if options.material? && !(options.material instanceof SceneMaterial)
        throw new Error("Material must be instance of SceneMaterial")
      super options
