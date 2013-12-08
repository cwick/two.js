define ["box"], (Box) ->
  describe 'Box', ->
    it "updates its bounding box when the size changes", ->
      box = new Box(width: 10, height: 20)
      box.setSize 5, 10
      bounds = box.getBoundingBox()

      expect(bounds.getWidth()).toEqual 5
      expect(bounds.getHeight()).toEqual 10

