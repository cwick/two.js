define ["jquery", "./mouse_buttons", "./utils"], ($, MouseButtons, Utils) ->
  enhance: (domElement) ->
    $(domElement).find('.drag-handle').on 'mousedown', (e) => @_onDrag(e)

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

      Utils.setTranslation $draggable, x, y

    $(document).one "mouseup", ->
      $(document).off 'mousemove.draggable'

