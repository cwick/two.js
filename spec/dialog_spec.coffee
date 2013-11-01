define ["editor/dialog", "jquery", "jquery.simulate"], (Dialog, $) ->
  describe 'Dialog', ->
    dialog = $container = $domElement = null

    assertLocation = (x, y) ->
      expect($domElement.css("-webkit-transform")).toEqual "translate3d(#{x}px, #{y}px, 0)"

    simulateDrag = (dx, dy) ->
      $domElement.find(".drag-handle").simulate("drag", dx: dx, dy: dy)

    beforeEach ->
      dialog = new Dialog()
      $domElement = dialog.$domElement

      $container = $("<div/>")
      $container.width(500)
      $container.height(500)
      $container.append $domElement


    it "can be dragged around the page", ->
      simulateDrag 10, 5
      assertLocation 10, 5

    it "cannot be dragged outside of its parent element", ->
      simulateDrag -999, -999
      assertLocation 0, 0

      simulateDrag 999, 999
      assertLocation $container.width() - $domElement.width(), $container.height() - $domElement.height()

    it "can be resized from the right", ->
      oldWidth = $domElement.width()

      $domElement.find(".right-resize").simulate("mousedown")
      $domElement.find(".right-resize").simulate("drag", dx: 10, dy: -5)
      expect($domElement.width()).toEqual(oldWidth + 10)

    it "cannot be resized such that it hangs off-screen", ->
      $domElement.find(".right-resize").simulate("mousedown")
      $domElement.find(".right-resize").simulate("drag", dx: 999)
      expect($domElement.outerWidth()).toEqual(500)

