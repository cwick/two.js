define ["jquery"], ($) ->
  class
    constructor: ->

      $('.drag-handle').on 'mousedown', (e) ->
        $handle = $(e.target)
        offsetX = e.offsetX
        offsetY = e.offsetY
        $(document).on 'mousemove.draggable', (e) ->
          $draggable = $handle.closest('.draggable')
          $draggable.css("-webkit-transform": "translate3d(#{e.clientX-offsetX}px,#{e.clientY-offsetY}px,0)")

      $(document).mouseup (e) ->
        $(document).off 'mousemove.draggable'


