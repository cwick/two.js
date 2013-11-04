define (require) ->
  BoundingDisc = require "bounding_disc"

  describe "BoundingDisc", ->
    describe "#applyMatrix", ->
      it "should transform the disc by the specified matrix", ->
        disc = new BoundingDisc(x: 10, y: 10, radius: 4)

        disc.applyMatrix([1,0,0,1,4,5])

        expect(disc.getPosition()).toEqual [14,15]

