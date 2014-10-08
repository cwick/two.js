`import TwoObject from "./object"`
`import Property from "./property"`

SceneNode = TwoObject.extend
  initialize: ->
    @enabled = true
    @_children = []
    @_parent = null

  children: Property readonly: true

  parent: Property readonly: true

  _setParent: (value) ->
    @_parent = value

  add: (child) ->
    if @_children.indexOf(child) == -1
      @_children.push child

      child.parent?.remove child
      child._setParent(@)

    child

  remove: (child) ->
    idx = @_children.indexOf child
    if idx != -1
      @_children.splice(idx, 1)
      child._setParent(null)

  removeAll: ->
    children = @_children
    @_children = []

    child._setParent(null) for child in children

`export default SceneNode`

