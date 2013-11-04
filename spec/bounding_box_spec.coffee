define (require) ->
  BoundingBox = require "bounding_box"

  describe "BoundingBox", ->
    describe "#applyMatrix", ->
      it "should transform the box by the specified matrix", ->
        box = new BoundingBox(x: 10, y: 10, width: 5, height: 10)

        box.applyMatrix([1,0,0,1,4,5])
        expect(box.getPosition()).toEqual [14,15]
