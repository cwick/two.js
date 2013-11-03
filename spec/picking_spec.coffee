define (require) ->
  Scene = require "scene"
  Camera = require "camera"
  Disc = require "disc"
  Box = require "box"
  Projector = require "projector"

  projector = scene = camera = renderer = null

  describe 'Picking an object from a scene', ->
    beforeEach ->
      scene = new Scene()
      camera = new Camera(width: 100)
      renderer =
        getWidth: -> 500
        getHeight: -> 500
      projector = new Projector(camera, renderer)

    it "can pick a disc object", ->
      disc = new Disc(radius: 5)
      scene.add(disc)

      expect(projector.pick([0, 0], scene)).toBe null
      expect(projector.pick([260, 245], scene)).toBe disc

    it "can pick a box object", ->
      box = new Box(width: 10, height: 20)
      scene.add(box)

      expect(projector.pick([0,0], scene)).toBe null
      expect(projector.pick([260, 235], scene)).toBe box

