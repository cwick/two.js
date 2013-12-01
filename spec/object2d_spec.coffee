define (require) ->
  Object2d = require "object2d"

  describe "Object2d", ->
    it "is positioned at (0,0) by default", ->
      object = new Object2d()
      expect(object.getPosition()).toEqual [0,0]

    it "has a world matrix", ->
      object = new Object2d(x: 3, y: 4)
      expect(object.getWorldMatrix()).toEqual [1,0,0,1,3,4]

    it "caches its bounding box", ->
      object = new Object2d()
      spyOn(object, "_recomputeBoundingBox").andCallThrough()

      object.getBoundingBox()
      object.getBoundingBox()

      expect(object._recomputeBoundingBox.callCount).toEqual 1

    describe "when its position changes", ->
      object = null
      beforeEach ->
        object = new Object2d(x: 3, y: 4)

      it "updates its world matrix", ->
        object.getWorldMatrix()
        object.setPosition [9,10]
        expect(object._isWorldMatrixValid).toBe false
        expect(object.getWorldMatrix()).toEqual [1,0,0,1,9,10]
        expect(object._isWorldMatrixValid).toBe true

      it "updates its bounding box", ->
        object.getBoundingBox()
        object.setPosition [3,4]

        expect(object._isBoundingBoxValid).toBe false
        object.getBoundingBox()
        expect(object._isBoundingBoxValid).toBe true

    describe "when a parent's position changes", ->
      parent = child1 = child2 = null

      beforeEach ->
        parent = new Object2d()
        child1 = new Object2d(x: 1, y: 2)
        child2 = new Object2d(x: 3, y: 4)

        parent.add child1
        parent.add child2

        spyOn(child1, "_recomputeBoundingBox").andCallThrough()
        spyOn(child2, "_recomputeBoundingBox").andCallThrough()

      it "the children's world matrices are updated", ->
        child1.getWorldMatrix()
        child2.getWorldMatrix()

        parent.setPosition [10, 10]
        expect(child1.getWorldMatrix()).toEqual [1,0,0,1,11,12]
        expect(child2.getWorldMatrix()).toEqual [1,0,0,1,13,14]

      it "the children's bounding boxes are updated", ->
        child1.getBoundingBox()
        child2.getBoundingBox()

        parent.setPosition [10, 10]

        child1.getBoundingBox()
        child2.getBoundingBox()

        expect(child1._recomputeBoundingBox.callCount).toEqual 2
        expect(child2._recomputeBoundingBox.callCount).toEqual 2

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

    describe "when adding a child to multiple parents", ->
      parent1 = parent2 = child = null

      beforeEach ->
        child = new Object2d()
        parent1 = new Object2d()
        parent2 = new Object2d()

        parent1.add child
        parent2.add child

      it "gets removed from its former parent", ->
        expect(child.getParent()).toBe parent2
        expect(parent1.getChildren()).toEqual []
        expect(parent2.getChildren()).toEqual [child]

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
