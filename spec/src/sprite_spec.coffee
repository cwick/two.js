`import Sprite from "sprite"`

class DummyImage extends Image
  constructor: (options) ->
    @width = options.width
    @height = options.height
    @complete = true

describe "Sprite", ->
  it "converts a URL into an Image object", ->
    sprite = new Sprite(image: "http://some_url/", usePlaceholder: false)
    expect(sprite.image instanceof Image).toBe true
    expect(sprite.image.src).toEqual "http://some_url/"

  it "defaults origin to [0,0]", ->
    sprite = new Sprite(image: new DummyImage(width: 10, height: 10))
    expect(sprite.origin).toEqual [0,0]
    expect(sprite.pixelOrigin).toEqual [0,0]

  it "supports center origin", ->
    sprite = new Sprite(image: new DummyImage(width: 10, height: 10), origin: "center")
    expect(sprite.origin).toEqual "center"
    expect(sprite.pixelOrigin).toEqual [5,5]

  it "supports absolute pixel origin", ->
    sprite = new Sprite(image: new DummyImage(width: 100, height: 100), origin: [3,3])
    expect(sprite.origin).toEqual [3,3]
    expect(sprite.pixelOrigin).toEqual [3,3]

  it "throws an error when an invalid origin is passed", ->
    expect(->
      new Sprite
        image: new DummyImage(width: 100, height: 100)
        origin: "invalid")
      .toThrow new Error("Invalid value \"invalid\" for origin")

  it "can be cloned", ->
    image = new DummyImage(width: 100, height: 100)
    sprite = new Sprite(image: image, origin: [3,3], width: 10, height: 20)
    clone = sprite.clone()
    expect(clone.image).toBe image
    expect(clone.origin).toEqual [3,3]
    expect(clone.width).toEqual 10
    expect(clone.height).toEqual 20
