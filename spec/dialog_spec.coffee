define ["editor/dialog", "jquery", "jquery.simulate"], (Dialog, $) ->
  describe 'Dialog', ->
    dialog = $domElement = null

    beforeEach ->
      dialog = new Dialog()
      $domElement = dialog.$domElement

    it "can be dragged around the page", ->
      $domElement.find(".drag-handle").simulate("drag", dx: 10, dy: -5)
      expect($domElement.css("-webkit-transform")).toEqual "translate3d(10px, -5px, 0)"

    it "can be resized from the right", ->
      oldWidth = $domElement.width()

      $domElement.find(".right-resize").simulate("mousedown")
      $domElement.find(".right-resize").simulate("drag", dx: 10, dy: -5)
      expect($domElement.width()).toEqual(oldWidth + 10)

