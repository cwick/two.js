define (require) ->
  Scene = require "scene"
  Camera = require "camera"
  Disc = require "disc"
  Box = require "box"

  scene = camera = renderer = null

  describe 'Picking an object from a scene', ->
    beforeEach ->
      scene = new Scene()
      camera = new Camera(width: 100)
      renderer =
        getWidth: -> 500
        getHeight: -> 500

    it "can pick a disc object", ->
      disc = new Disc(radius: 5)
      scene.add(disc)

      expect(camera.pick([0, 0], scene, renderer)).toBe null
      expect(camera.pick([260, 245], scene, renderer)).toBe disc

    it "can pick a box object", ->
      box = new Box(width: 10, height: 20)
      scene.add(box)

      expect(camera.pick([0,0], scene, renderer)).toBe null
      expect(camera.pick([260, 235], scene, renderer)).toBe box

