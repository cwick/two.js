`import Mixin from "./mixin"`
`import Property from "./property"`
`import CanHaveParent from "./can_have_parent"`

CanGroup = Mixin.create
  initialize: ->
    @_children = []

  children: Property readonly: true

  add: (child) ->
    if @_children.indexOf(child) == -1
      @_children.push child
      if CanHaveParent.detect(child)
        child.parent?.remove child
        child._setParent(@)

    child

  remove: (child) ->
    idx = @_children.indexOf child
    if idx != -1
      @_children.splice(idx, 1)
      if CanHaveParent.detect(child)
        child._setParent(null)

  removeAll: ->
    children = @_children.slice(0)
    @remove child for child in children
    @


`export default CanGroup`
