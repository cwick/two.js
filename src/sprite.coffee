`import TwoObject from "./object"`
`import Property from "./property"`
`import Canvas from "./canvas"`

Sprite = TwoObject.extend
  initialize: ->
    @anchorPoint = [0.5, 0.5]
    @crop = null

  clone: ->
    new Sprite
      image: @_image
      anchorPoint: @anchorPoint.slice(0)
      width: @width
      height: @height
      crop: @crop?.clone()

  width: Property
    get: ->
      return @_width if @_width?
      return @crop.width if @crop
      return @_image.width if @_image.width
      null

    set: (value) ->
      @_width = value

  height: Property
    get: ->
      return @_height if @_height?
      return @crop.height if @crop
      return @_image.height if @_image.height
      null

    set: (value) ->
      @_height = value

  pixelOrigin: Property
    get: ->
      width = @width
      height = @height

      return [0,0] unless width? && height?

      [
        @anchorPoint[0] * width,
        height - @anchorPoint[1] * height
      ]

  image: Property
    set: (value) ->
      if typeof value is "string"
        @_image = new Image()
        @_image.src = value
      else
        @_image = value

  pushRenderCommands: (commands, transform) ->
    image = @_image
    scaleX = scaleY = 1

    if @width && image.width
      scaleX = @width / image.width
    if @height && image.height
      scaleY = @height / image.height

    transform.scale scaleX, scaleY

    commands.push
      name: "drawImage"
      image: image
      transform: transform
      origin: @pixelOrigin
      crop: @crop || {
        x: 0
        y: 0
        width: image.width
        height: image.height }

`export default Sprite`
