define ["jquery", "./control"], ($, Control) ->
  class Toolbar extends Control
    constructor: (options) ->
      super $("<ul/>", class: "toolbar")

      if options.orientation == "vertical"
        @$domElement.addClass "toolbar-vertical"
        @$domElement.removeClass "toolbar"

    addItem: (item) ->
      wrapper = $("<li/>")
      wrapper.append item
      @$domElement.append wrapper
      item

    activate: (item) ->
      @$domElement.find("button").removeClass "active"
      $(item).addClass "active"
