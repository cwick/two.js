define ["jquery"], ($) ->
  class
    constructor: ->
      $('.drag-handle').on 'mousedown', (e) ->
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


      $('.resizable .right-resize').on 'mousedown', (e) ->
        $handle = $(e.target)
        $resizable = $handle.closest('.resizable')

        startX = e.clientX
        startY = e.clientY
        startWidth = $resizable.width()

        $(document).on 'mousemove.resizable', (e) ->
          $resizable.width(startWidth + e.clientX - startX)

      $(document).mouseup (e) ->
        $(document).off 'mousemove.resizable'


