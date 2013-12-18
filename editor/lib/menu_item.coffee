define ["jquery", "signals", "./control"], ($, Signal, Control) ->
  class MenuItem extends Control
    constructor: (options) ->
      super $("<li/>", class: "menu-item")

      @name = options.name
      @$domElement.append $("<span/>", class: "submenu-gutter")
      @$domElement.append $("<span/>", html: @name)

      @$domElement.mousedown (e) => @_onMouseDown(e)
      @$domElement.mouseenter (e) => @_onMouseEnter(e)
      @$domElement.mouseleave (e) => @_onMouseLeave(e)
      @$domElement.mouseup (e) => @_onMouseUp(e)

      @selected = new Signal()
      @_isChecked = false
      @_isCheckable = options.isCheckable

    check: ->
      @$domElement.find(".submenu-gutter").html("&#x2713;")
      @_isChecked = true

    uncheck: ->
      @$domElement.find(".submenu-gutter").empty()
      @_isChecked = false

    isChecked: ->
      @_isChecked

    _onMouseEnter: ->
      return if MenuItem.isSelectionInProgress
      @_activate()
      @$domElement.siblings().removeClass "active"

    _onMouseLeave: ->
      return if MenuItem.isSelectionInProgress
      @_deactivate()

    _onMouseDown: (e) ->
      e.stopPropagation()

    _onMouseUp: ->
      return if MenuItem.isSelectionInProgress
      MenuItem.isSelectionInProgress = true

      @_deactivate()
      setTimeout (=>
        @_activate()
        setTimeout (=>
          MenuItem.isSelectionInProgress = false
          @$domElement.trigger "menuItemSelected"
          if @_isCheckable
            if @isChecked() then @uncheck() else @check()
          @selected.dispatch(@)
        ), 90
      ), 40

    _activate: ->
      @$domElement.addClass "active"

    _deactivate: ->
      @$domElement.removeClass "active"
