define ["jquery", "./control"], ($, Control) ->
  class Submenu extends Control
    constructor: (options) ->
      super $("<ul/>", class: "submenu")

      @name = options.name

    addItem: (item) ->
      @$domElement.append item.domElement
      item

    open: (top, left) ->
      $("body").find(".submenu").detach()
      @$domElement.css "top", top
      @$domElement.css "left", left
      @$domElement.find(".menu-item").removeClass "active"

      $("body").append @$domElement
