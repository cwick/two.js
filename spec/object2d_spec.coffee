define (require) ->
  Object2d = require "object2d"

  MockBoundingBox = MockBoundingDisc = class
    constructor: -> spyOn @, "applyMatrix"
    applyMatrix: ->

  describe "Object2d", ->
    it "is positioned at (0,0) by default", ->
      object = new Object2d()
      expect(object.getPosition()).toEqual [0,0]

    it "has a world matrix", ->
      object = new Object2d(x: 3, y: 4)
      expect(object.getWorldMatrix()).toEqual [1,0,0,1,3,4]

    it "caches its bounding box", ->
      object = new Object2d()
      object._createBoundingBox = -> new MockBoundingBox()
      spyOn(object, "_createBoundingBox").andCallThrough()

      object.getBoundingBox()
      object.getBoundingBox()

      expect(object._createBoundingBox.callCount).toEqual 1

    it "caches its bounding disc", ->
      object = new Object2d()
      object._createBoundingDisc = -> new MockBoundingDisc()
      spyOn(object, "_createBoundingDisc").andCallThrough()

      object.getBoundingDisc()
      object.getBoundingDisc()

      expect(object._createBoundingDisc.callCount).toEqual 1

    describe "when its position changes", ->
      object = null
      beforeEach ->
        object = new Object2d(x: 3, y: 4)

      it "updates its world matrix", ->
        object.getWorldMatrix()
        object.setPosition [9,10]
        expect(object.getWorldMatrix()).toEqual [1,0,0,1,9,10]

      it "updates its bounding box", ->
        object._createBoundingBox = -> new MockBoundingBox()
        spyOn(object, "_createBoundingBox").andCallThrough()

        object.getBoundingBox()
        object.setPosition [3,4]
        object.getBoundingBox()

        expect(object._createBoundingBox.callCount).toEqual 2

      it "updates its bounding disc", ->
        object._createBoundingDisc = -> new MockBoundingDisc()
        spyOn(object, "_createBoundingDisc").andCallThrough()

        object.getBoundingDisc()
        object.setPosition [3,4]
        object.getBoundingDisc()

        expect(object._createBoundingDisc.callCount).toEqual 2

    describe "when a parent's position changes", ->
      parent = child1 = child2 = null

      beforeEach ->
        parent = new Object2d()
        child1 = new Object2d(x: 1, y: 2)
        child2 = new Object2d(x: 3, y: 4)
        parent.add child1
        parent.add child2

      it "the children's world matrices get updated", ->
        child1.getWorldMatrix()
        child2.getWorldMatrix()

        parent.setPosition [10, 10]
        expect(child1.getWorldMatrix()).toEqual [1,0,0,1,11,12]
        expect(child2.getWorldMatrix()).toEqual [1,0,0,1,13,14]

      it "the children's bounding boxes get updated", ->
        box1 = new MockBoundingBox()
        box2 = new MockBoundingBox()

        child1._createBoundingBox = -> box1
        child2._createBoundingBox = -> box2

        child1.getBoundingBox()
        child2.getBoundingBox()

        parent.setPosition [10, 10]

        child1.getBoundingBox()
        child2.getBoundingBox()

        expect(box1.applyMatrix.callCount).toEqual 2
        expect(box1.applyMatrix).toHaveBeenCalledWith(parent.getWorldMatrix())
        expect(box2.applyMatrix.callCount).toEqual 2
        expect(box2.applyMatrix).toHaveBeenCalledWith(parent.getWorldMatrix())

      it "the children's bounding discs get updated", ->
        disc1 = new MockBoundingDisc()
        disc2 = new MockBoundingDisc()

        child1._createBoundingDisc = -> disc1
        child2._createBoundingDisc = -> disc2

        child1.getBoundingDisc()
        child2.getBoundingDisc()

        parent.setPosition [10, 10]

        child1.getBoundingDisc()
        child2.getBoundingDisc()

        expect(disc1.applyMatrix.callCount).toEqual 2
        expect(disc2.applyMatrix.callCount).toEqual 2

    describe "when adding children", ->
      parent = child = null

      beforeEach ->
        parent = new Object2d()
        child = new Object2d()
        parent.add child

      it "updates its 'children' collection", ->
        expect(parent.getChildren().length).toEqual 1
        expect(parent.getChildren()[0]).toBe child

      it "sets the 'parent' property of its children", ->
        expect(child.getParent()).toBe parent

    describe "when removing children", ->
      parent = child = null

      beforeEach ->
        parent = new Object2d()
        child = new Object2d()
        parent.add child
        parent.remove child

      it "updates its 'children' collection", ->
        expect(parent.getChildren().length).toEqual 0

      it "clears the 'parent' property of its former children", ->
        expect(child.getParent()).toBeNull()
