define ["jquery"], ($) ->
  class
    constructor: ->
      @$domElement = $("<div/>", class: "dialog draggable resizable")
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
                "panel dialog-header drag-handle",
                "dialog-body",
                "dialog-footer"]
        @$domElement.append $("<div/>", class: c)

      # console.log(new XMLSerializer().serializeToString(@$domElement.get(0)).replace(///\s+xmlns="http://www.w3.org/1999/xhtml"///g, ""))

      @$domElement.find('.drag-handle').on 'mousedown', @onDrag
      @$domElement.find('.right-resize, .bottom-right-resize, .top-right-resize').on 'mousedown', @onResize

    onDrag: (e) ->
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

    onResize: (e) ->
      $handle = $(e.target)
      $resizable = $handle.closest('.resizable')

      startX = e.clientX
      startWidth = $resizable.width()

      parentWidth = $resizable.parent().width()

      outerWidth = $resizable.outerWidth()
      innerWidth = $resizable.innerWidth()

      position = $resizable.position()

      maxWidth = parentWidth - position.left - (outerWidth - innerWidth)

      $(document).on 'mousemove.resizable', (e) ->
        $resizable.width(Math.min(startWidth + e.clientX - startX, maxWidth))

      $(document).one "mouseup", ->
        $(document).off 'mousemove.resizable'

    setBody: (value) -> @$domElement.find(".dialog-body").html(value)
    setFooter: (value) -> @$domElement.find(".dialog-footer").html(value)

