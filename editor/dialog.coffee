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
                "panel header drag-handle",
                "body",
                "footer"]
        @$domElement.append $("<div/>", class: c)

      # console.log(new XMLSerializer().serializeToString(@$domElement.get(0)).replace(///\s+xmlns="http://www.w3.org/1999/xhtml"///g, ""))

      @$domElement.find('.drag-handle').on 'mousedown', (e) ->
        $handle = $(e.target)
        $draggable = $handle.closest('.draggable')

        offsetX = e.offsetX
        offsetY = e.offsetY
        borderTop = $draggable[0].clientTop
        borderLeft = $draggable[0].clientLeft

        $(document).on 'mousemove.draggable', (e) ->
          $draggable.css("-webkit-transform": "translate3d(#{e.clientX-offsetX-borderLeft}px,#{e.clientY-offsetY-borderTop}px,0)")

      $(document).mouseup (e) ->
        $(document).off 'mousemove.draggable'

      @$domElement.find('.right-resize').on 'mousedown', (e) ->
        $handle = $(e.target)
        $resizable = $handle.closest('.resizable')

        startX = e.clientX
        startY = e.clientY
        startWidth = $resizable.width()

        $(document).on 'mousemove.resizable', (e) ->
          $resizable.width(startWidth + e.clientX - startX)

      $(document).mouseup (e) ->
        $(document).off 'mousemove.resizable'


    setBody: (value) -> @$domElement.find(".body").html(value)
    setFooter: (value) -> @$domElement.find(".footer").html(value)
