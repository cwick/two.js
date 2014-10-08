`import TwoObject from "./object"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`
`import SceneNode from "./scene_node"`

GroupNode = SceneNode.extend
  initialize: ->
    @_matrix = new Matrix2d()
    @_worldMatrix = new Matrix2d()
    @_children = []

  children: Property readonly: true
  matrix: Property readonly: true
  worldMatrix: Property readonly: true

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

  # Implement in subclass
  updateMatrix: ->

  updateWorldMatrix: ->
    @_worldMatrix.reset()
    matrices = []
    parent = @_parent

    matrices.push @_matrix

    while parent
      matrices.push parent._matrix
      parent = parent._parent

    for m in matrices by -1
      @_worldMatrix.multiply(m)

    @_worldMatrix

`export default GroupNode`


