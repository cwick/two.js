`import TwoObject from "./object"`
`import Rectangle from "./rectangle"`
`import Property from "./property"`

Renderable = TwoObject.extend
  initialize: ->

  bounds: Property
    get: -> new Rectangle()

  ###*
  #
  # @method generateRenderCommands
  # @return An array of render commands, or a single render command, that will render this node
  ###
  generateRenderCommands: -> []

`export default Renderable`
