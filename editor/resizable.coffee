define ["jquery", "./mouse_buttons", "./utils"], ($, MouseButtons, Utils) ->
  enhance: (domElement) ->
    $domElement = $(domElement)
    $domElement.find('.right-resize').on 'mousedown', (e) => @_onResize e, right: true
    $domElement.find('.left-resize').on 'mousedown', (e) => @_onResize e, left: true
    $domElement.find('.bottom-resize').on 'mousedown', (e) => @_onResize e, down: true
    $domElement.find('.top-resize').on 'mousedown', (e) => @_onResize e, up: true
    $domElement.find('.top-right-resize').on 'mousedown', (e) => @_onResize e, up: true, right: true
    $domElement.find('.top-left-resize').on 'mousedown', (e) => @_onResize e, up: true, left: true
    $domElement.find('.bottom-right-resize').on 'mousedown', (e) => @_onResize e, down: true, right: true
    $domElement.find('.bottom-left-resize').on 'mousedown', (e) => @_onResize e, down: true, left: true

  _onResize: (e, options) ->
    return unless e.which == MouseButtons.LEFT

    $resizable = $(e.target).closest('.resizable')

    metrics = @_getResizeMetrics(e, $resizable)
    newLeft = metrics.startLeft
    newTop = metrics.startTop

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

      Utils.setTranslation $resizable, newLeft, newTop

    $(document).one "mouseup", ->
      $(document).off 'mousemove.resizable'

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

