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

    parent = $draggable.parent()

    parentWidth = parent.width()
    parentHeight = parent.height()

    parentTop = parent.position().top
    parentLeft = parent.position().left

    $(document).on 'mousemove.draggable', (e) =>
      x = initialTranslation[0] + e.pageX - startX
      y = initialTranslation[1] + e.pageY - startY

      x = Math.max(parentLeft, x)
      y = Math.max(parentTop, y)

      x = Math.min(parentWidth  - outerWidth + parentLeft, x)
      y = Math.min(parentHeight - outerHeight + parentTop, y)

      Utils.setTranslation $draggable, x, y

    $(document).one "mouseup", ->
      $(document).off 'mousemove.draggable'

