`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import CanGroup from "./can_group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`
`import SceneNode from "./scene_node"`

GroupNode = SceneNode.extend CanHaveParent, CanGroup,
  initialize: ->
    @_matrix = new Matrix2d()
    @_worldMatrix = new Matrix2d()

  matrix: Property readonly: true
  worldMatrix: Property readonly: true

  add: (child) ->
    throw new Error("Child nodes must implement CanHaveParent") unless CanHaveParent.detect(child)
    CanGroup.properties.add.call @, child

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

