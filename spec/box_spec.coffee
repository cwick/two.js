define ["box"], (Box) ->
  describe 'Box', ->
    it "updates its bounding box when the scale changes", ->
      box = new Box(width: 10, height: 20)
      box.setScale 0.5
      bounds = box.getBoundingBox()

      expect(bounds.getWidth()).toEqual 5
      expect(bounds.getHeight()).toEqual 10

