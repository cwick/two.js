`import TwoObject from "./object"`
`import Size from "./size"`
`import Property from "./property"`

Renderable = TwoObject.extend
  initialize: ->

  bounds: Property
    get: -> new Size()

  ###*
  #
  # @method generateRenderCommands
  # @return An array of render commands, or a single render command, that will render this node
  ###
  generateRenderCommands: -> []

`export default Renderable`
