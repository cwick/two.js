`import Mixin from "./mixin"`
`import Property from "./property"`

Hierarchical = Mixin.create
  initialize: ->
    @_parent = null
    @_children = []

  children: Property readonly: true
  parent: Property readonly: true

  _setParent: (value) ->
    @_parent = value

  add: (child) ->
    if @_children.indexOf(child) == -1
      @_children.push child
      child.parent?.remove child
      child._setParent(@_base)

  remove: (child) ->
    idx = @_children.indexOf child
    if idx != -1
      @_children.splice(idx, 1)
      child._setParent(null)


`export default Hierarchical`
