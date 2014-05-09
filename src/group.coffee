`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import CanGroup from "./can_group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`

GroupNode = TwoObject.extend CanHaveParent, CanGroup,
  initialize: ->
    @_matrix = new Matrix2d()
    @_worldMatrix = new Matrix2d()

  matrix: Property readonly: true

  # TODO: inefficient and naive implementation
  worldMatrix: Property
    get: ->
      @_worldMatrix.reset()
      matrices = []
      parent = @parent

      matrices.push @matrix

      while parent
        matrices.push parent.matrix
        parent = parent.parent

      for m in matrices by -1
        @_worldMatrix.multiply(m)

      @_worldMatrix

`export default GroupNode`


