define ->
  class Tool
    constructor: (@editor) ->

    onActivated: ->
      @_isActive = true

    onDeactivated: ->
      @_isActive = false

    onDeselected: ->
      @_isSelected = false

    onSelected: ->
      @_isSelected = true

    onDragged: ->
    onMoved: ->

    isActive: -> @_isActive
    isSelected: -> @_isSelected


