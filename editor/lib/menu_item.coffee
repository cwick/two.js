define ["jquery", "./control"], ($, Control) ->
  class MenuItem extends Control
    constructor: (options) ->
      super $("<li/>", class: "menu-item")

      @name = options.name
      @$domElement.html @name

      @$domElement.mousedown (e) -> e.stopPropagation()
      @$domElement.mouseenter (e) =>
        @$domElement.addClass "active"
        @$domElement.siblings().removeClass "active"

