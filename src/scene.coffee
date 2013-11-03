define ->
  class Scene
    constructor: ->
      @objects = []

    add: (object) -> @objects.push object
    remove: (object) ->
      idx = @objects.indexOf object
      @objects.splice(idx, 1) if idx != -1

    getChildren: ->
      @objects

