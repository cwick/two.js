define ["jquery", "./control"], ($, Control) ->
  class Submenu extends Control
    constructor: (options) ->
      super $("<ul/>", class: "submenu")

      @name = options.name

    addItem: (item) ->
      @$domElement.append item.domElement
      item
