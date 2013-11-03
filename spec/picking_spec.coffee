define (require) ->
  Scene = require "scene"
  Camera = require "camera"
  Disc = require "disc"

  describe 'Picking an object from a scene', ->
    it "can pick a disc object", ->
      scene = new Scene()
      camera = new Camera(width: 100, screenWidth: 500, screenHeight: 500)
      disc = new Disc(radius: 5)
      scene.add(disc)

      expect(camera.pick([0, 0], scene)).toBe null
      expect(camera.pick([260, 245], scene)).toBe disc

