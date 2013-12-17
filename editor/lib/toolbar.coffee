define ["jquery", "./control"], ($, Control) ->
  class Toolbar extends Control
    constructor: (options) ->
      super $("<ul/>", class: "toolbar")

      if options.orientation == "vertical"
        @$domElement.addClass "toolbar-vertical"
        @$domElement.removeClass "toolbar"

    addItem: (item) ->
      wrapper = $("<li/>", class: "toolbar-item")
      wrapper.append item
      @$domElement.append wrapper
      item

    activate: (item) ->
      toolbarItem = $(item).closest(".toolbar-item")
      toolbarItem.siblings().removeClass "active"
      toolbarItem.addClass "active"
