define ["jquery", "./control"], ($, Control) ->
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

    _onMouseEnter: ->
      @_activate()
      @$domElement.siblings().removeClass "active"

    _onMouseLeave: ->
      @_deactivate()

    _onMouseDown: (e) ->
      e.stopPropagation()

    _onMouseUp: ->
      @_deactivate()
      setTimeout (=>
        @_activate()
        setTimeout (=> @$domElement.trigger "menuItemSelected"), 100
      ), 65

    _activate: ->
      @$domElement.addClass "active"

    _deactivate: ->
      @$domElement.removeClass "active"
