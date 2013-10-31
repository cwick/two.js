define ["jquery"], ($) ->
  class
    constructor: ->
      $('.drag-handle').on 'mousedown', (e) ->
        $handle = $(e.target)
        $(document).on 'mousemove.draggable', (e) ->
          $draggable = $handle.closest('.draggable')
          $draggable.css("-webkit-transform": "translate3d(#{e.clientX}px,#{e.clientY}px,0)")

      $(document).mouseup (e) ->
        $(document).off 'mousemove.draggable'


