define ["jquery", "./control"], ($, Control) ->
  class MenuItem extends Control
    constructor: (options) ->
      super $("<li/>", class: "menu-item")

      @name = options.name
      @$domElement.html @name

