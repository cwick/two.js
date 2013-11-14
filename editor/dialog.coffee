define ["jquery", "./mouse_buttons"], ($, MouseButtons) ->
  class
    constructor: ->
      @$domElement = $("<div/>", class: "panel dialog draggable resizable")
      @domElement = @$domElement.get(0)

      @$domElement.width "200px"

      for c in ["bottom-resize"
                "top-resize",
                "right-resize",
                "left-resize",
                "bottom-left-resize",
                "bottom-right-resize",
                "top-left-resize",
                "top-right-resize",
                "dialog-header drag-handle",
                "dialog-body",
                "dialog-footer"]
        @$domElement.append $("<div/>", class: c)

      @$domElement.find('.drag-handle').on 'mousedown', @_onDrag
      @$domElement.find('.right-resize, .top-right-resize').on 'mousedown', (e) => @_onResize e, right: true
      @$domElement.find('.bottom-right-resize').on 'mousedown', (e) => @_onResize e, down: true, right: true

    setBody: (value) ->
      @$domElement.find(".dialog-body").html(value)

    setFooter: (value) ->
      @$domElement.find(".dialog-footer").html(value)

    _onDrag: (e) ->
      return unless e.which == MouseButtons.LEFT
      $handle = $(e.target)
      $draggable = $handle.closest('.draggable')

      offsetX = e.offsetX
      offsetY = e.offsetY

      borderTop = $draggable[0].clientTop
      borderLeft = $draggable[0].clientLeft

      outerWidth = $draggable.outerWidth()
      outerHeight = $draggable.outerHeight()

      parentWidth = $draggable.parent().width()
      parentHeight = $draggable.parent().height()

      $(document).on 'mousemove.draggable', (e) ->
        x = Math.max(e.clientX-offsetX-borderLeft, 0)
        y = Math.max(e.clientY-offsetY-borderTop, 0)

        x = Math.min(parentWidth  - outerWidth, x)
        y = Math.min(parentHeight - outerHeight, y)

        $draggable.css("-webkit-transform": "translate3d(#{x}px,#{y}px,0)")

      $(document).one "mouseup", ->
        $(document).off 'mousemove.draggable'

    _onResize: (e, options) ->
      return unless e.which == MouseButtons.LEFT
      $handle = $(e.target)
      $resizable = $handle.closest('.resizable')

      startX = e.clientX
      startY = e.clientY
      startWidth = $resizable.width()
      startHeight = $resizable.height()

      parentWidth = $resizable.parent().width()
      parentHeight = $resizable.parent().height()

      outerWidth = $resizable.outerWidth()
      outerHeight = $resizable.outerHeight()
      innerWidth = $resizable.innerWidth()

      position = $resizable.position()

      maxWidth = parentWidth - position.left - (outerWidth - innerWidth)
      maxHeight = parentHeight - position.top - (outerHeight - innerHeight)

      $(document).on 'mousemove.resizable', (e) ->
        if options.right
          $resizable.width(Math.min(startWidth + e.clientX - startX, maxWidth))
        if options.down
          $resizable.height(Math.min(startHeight + e.clientY - startY, maxHeight))


      $(document).one "mouseup", ->
        $(document).off 'mousemove.resizable'

