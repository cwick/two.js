`import Sprite from "sprite"`

class DummyImage extends Image
  constructor: (options) ->
    @width = options.width
    @height = options.height
    @complete = true

describe "Sprite", ->
  it "converts a URL into an Image object", ->
    sprite = new Sprite(image: "http://some_url/")
    expect(sprite.image instanceof Image).toBe true
    expect(sprite.image.src).toEqual "http://some_url/"

  it "defaults anchorPoint to [0.5,0.5]", ->
    sprite = new Sprite(image: new DummyImage(width: 10, height: 10))
    expect(sprite.anchorPoint).toEqual [0.5, 0.5]

  describe "pixelOrigin", ->
    beforeEach ->
      @sprite = new Sprite(image: new DummyImage(width: 10, height: 10))

    it "anchorPoint = [0.5, 0.5]", ->
      expect(@sprite.pixelOrigin).toEqual [5, 5]

    it "anchorPoint = [0, 0]", ->
      @sprite.anchorPoint = [0, 0]
      expect(@sprite.pixelOrigin).toEqual [0, 10]

    it "anchorPoint = [1, 1]", ->
      @sprite.anchorPoint = [1, 1]
      expect(@sprite.pixelOrigin).toEqual [10, 0]

    it "anchorPoint = [1, 0]", ->
      @sprite.anchorPoint = [1, 0]
      expect(@sprite.pixelOrigin).toEqual [10, 10]

  it "can be cloned", ->
    image = new DummyImage(width: 100, height: 100)
    sprite = new Sprite
      image: image
      anchorPoint: [3,3]
      width: 10
      height: 20
      crop:
        x: 2
        y: 3
        width: 4
        height: 5
        clone: -> @

    clone = sprite.clone()
    expect(clone.image).toBe image
    expect(clone.anchorPoint).toEqual [3,3]
    expect(clone.width).toEqual 10
    expect(clone.height).toEqual 20
    expect(clone.crop.x).toEqual 2
    expect(clone.crop.y).toEqual 3
    expect(clone.crop.width).toEqual 4
    expect(clone.crop.height).toEqual 5
