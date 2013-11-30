define ->
  class Tool
    constructor: (@editor) ->
      @cursors ?= {}

    onActivated: ->
      @_isActive = true
      @setCursor "activated"

    onDeactivated: ->
      @_isActive = false
      @setCursor "normal"

    onDeselected: ->
      @_isSelected = false

    onSelected: ->
      @_isSelected = true
      @setCursor "normal" unless @isActive()

    onDragged: ->
    onMoved: ->

    onEnteredCanvas: ->
    onLeftCanvas: ->

    isActive: -> @_isActive
    isSelected: -> @_isSelected

    setCursor: (type) ->
      @editor.on.cursorStyleChanged.dispatch(@cursors[type] || @cursors.normal || "auto")
