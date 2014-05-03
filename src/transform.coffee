`import TwoObject from "./object"`
`import CanHaveParent from "./can_have_parent"`
`import CanGroup from "./can_group"`
`import Property from "./property"`
`import Matrix2d from "./matrix2d"`

Transform = TwoObject.extend CanHaveParent, CanGroup,
  initialize: ->
    @_matrix = new Matrix2d()
    @_worldMatrix = new Matrix2d()

  matrix: Property()

  # TODO: inefficient and naive implementation
  worldMatrix: Property
    get: ->
      result = null
      matrices = []
      parent = @parent

      matrices.push @matrix

      while parent
        matrices.push parent.matrix
        parent = parent.parent

      for m in matrices by -1
        if result
          result = result.multiply(m)
        else
          result = m

      result

`export default Transform`
