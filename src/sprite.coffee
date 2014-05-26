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

  pixelOrigin: Property
    get: ->
      image = @image
      w = image.width
      h = image.height

      return [0,0] unless w? && h?

      [ @anchorPoint[0] * w,
        h - @anchorPoint[1] * h
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
