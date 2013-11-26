define ["jquery", "../mouse_buttons", "../utils"], ($, MouseButtons, Utils) ->
  enhance: (domElement) ->
    $(domElement).find('.drag-handle').on 'mousedown', (e) => @_onDrag(e)

  _onDrag: (e) ->
    return unless e.which == MouseButtons.LEFT
    $draggable = $(e.target).closest('.draggable')

    initialTranslation = Utils.getTranslation $draggable
    startX = e.pageX
    startY = e.pageY

    outerWidth = $draggable.outerWidth()
    outerHeight = $draggable.outerHeight()

    parentWidth = $draggable.parent().width()
    parentHeight = $draggable.parent().height()

    $(document).on 'mousemove.draggable', (e) =>
      x = initialTranslation[0] + e.pageX - startX
      y = initialTranslation[1] + e.pageY - startY

      x = Math.max(0, x)
      y = Math.max(0, y)

      x = Math.min(parentWidth  - outerWidth, x)
      y = Math.min(parentHeight - outerHeight+1, y)

      Utils.setTranslation $draggable, x, y

    $(document).one "mouseup", ->
      $(document).off 'mousemove.draggable'

