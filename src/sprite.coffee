`import Renderable from "./renderable"`
`import Property from "./property"`

Sprite = Renderable.extend
  initialize: ->
    @anchorPoint = Sprite.defaultAnchorPoint.slice(0)
    @crop = null
    @_frame = null
    @_frames = {}

  clone: ->
    new Sprite
      anchorPoint: @anchorPoint.slice(0)
      crop: @crop?.clone()
      _image: @_image
      _frames: @_frames
      _frame: @_frame

  width: Property
    get: ->
      return @crop.width if @crop
      return @_image.width if @_image.width
      null

  height: Property
    get: ->
      return @crop.height if @crop
      return @_image.height if @_image.height
      null

  pixelOrigin: Property
    get: ->
      width = @image.width
      height = @image.height

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

  frame: Property
    set: (value) ->
      @_frame = value
      if value?
        frame = @_frames[value]
      else
        frame = null

      @crop = frame

  addFrame: (name, frame) ->
    @_frames[name] ||= frame

  generateRenderCommands: (transform) ->
    image = @_image
    scaleX = scaleY = 1

    return {
      name: "drawImage"
      image: image
      origin: @pixelOrigin
      crop: @crop || {
        x: 0
        y: 0
        width: image.width
        height: image.height }
    }

Sprite.defaultAnchorPoint = [0.5, 0.5]

`export default Sprite`
