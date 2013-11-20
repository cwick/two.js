define ["jquery", "./mouse_buttons"], ($, MouseButtons) ->
  class Dialog
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

      @$domElement.find('.drag-handle').on 'mousedown', (e) => @_onDrag e
      @$domElement.find('.right-resize').on 'mousedown', (e) => @_onResize e, right: true
      @$domElement.find('.left-resize').on 'mousedown', (e) => @_onResize e, left: true
      @$domElement.find('.bottom-resize').on 'mousedown', (e) => @_onResize e, down: true
      @$domElement.find('.top-resize').on 'mousedown', (e) => @_onResize e, up: true
      @$domElement.find('.top-right-resize').on 'mousedown', (e) => @_onResize e, up: true, right: true
      @$domElement.find('.top-left-resize').on 'mousedown', (e) => @_onResize e, up: true, left: true
      @$domElement.find('.bottom-right-resize').on 'mousedown', (e) => @_onResize e, down: true, right: true
      @$domElement.find('.bottom-left-resize').on 'mousedown', (e) => @_onResize e, down: true, left: true

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

      $(document).on 'mousemove.draggable', (e) =>
        x = Math.max(e.clientX-offsetX-borderLeft, 0)
        y = Math.max(e.clientY-offsetY-borderTop, 0)

        x = Math.min(parentWidth  - outerWidth, x)
        y = Math.min(parentHeight - outerHeight, y)

        @_setTranslation $draggable, x, y

      $(document).one "mouseup", ->
        $(document).off 'mousemove.draggable'

    _onResize: (e, options) ->
      return unless e.which == MouseButtons.LEFT

      $resizable = $(e.target).closest('.resizable')

      metrics = @_getResizeMetrics(e, $resizable)
      newLeft = metrics.startLeft
      newTop = metrics.startTop

      console.log metrics
      $(document).on 'mousemove.resizable', (e) =>
        if options.right
          $resizable.width(Math.min(metrics.startWidth + e.clientX - metrics.startX, metrics.maxWidth))
        if options.down
          $resizable.height(Math.min(metrics.startHeight + e.clientY - metrics.startY, metrics.maxHeight))
        if options.up
          newTop = Math.max(metrics.startTop - (metrics.startY - e.clientY), 0)
          newHeight = metrics.startHeight - newTop + metrics.startTop

          $resizable.height(newHeight)
        if options.left
          newLeft = Math.max(metrics.startLeft - (metrics.startX - e.clientX), 0)
          newWidth = metrics.startWidth - newLeft + metrics.startLeft

          $resizable.width(newWidth)

        @_setTranslation $resizable, newLeft, newTop

      $(document).one "mouseup", ->
        $(document).off 'mousemove.resizable'

    _setTranslation: (e, x, y) ->
      e.css("-webkit-transform": "translate3d(#{x}px,#{y}px,0)")

    _getResizeMetrics: (e, $resizable) ->
      position = $resizable.position()
      parent = $resizable.parent()
      outerWidth = $resizable.outerWidth()
      outerHeight = $resizable.outerHeight()
      innerWidth = $resizable.innerWidth()
      innerHeight = $resizable.innerHeight()

      return {
        startX:       e.clientX
        startY:       e.clientY
        startWidth:   $resizable.width()
        startHeight:  $resizable.height()
        startTop:     position.top
        startLeft:    position.left
        parentWidth:  parent.width()
        parentHeight: parent.height()
        outerWidth:   outerWidth
        outerHeight:  outerHeight
        innerWidth:   innerWidth
        innerHeight:  innerHeight
        maxWidth:     parent.width() - position.left - (outerWidth - innerWidth)
        maxHeight:    parent.height() - position.top - (outerHeight - innerHeight)
      }

