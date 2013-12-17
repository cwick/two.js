define ["jquery", "./control"], ($, Control) ->
  class Menubar extends Control
    constructor: (options) ->
      super $("<ul/>", class: "menubar")

    addItem: (item) ->
      wrapper = $("<li/>", class: "menubar-item")
      wrapper.append item.name
      wrapper.data "submenu", item
      @$domElement.append wrapper
      @_bindMenuItemEventHandlers(wrapper)
      item

    activate: (item) ->
      menubarItem = item.closest(".menubar-item")
      menubarItem.siblings().removeClass "active"
      menubarItem.addClass "active"

      @_openSubmenu(menubarItem, item.data "submenu")

    _bindMenuItemEventHandlers: (item) ->
      item.click => @activate(item)

    _openSubmenu: (menubarItem, submenu) ->
      $("body").find(".submenu").detach()
      $("body").append submenu.$domElement
      submenu.$domElement.css "top", menubarItem.outerHeight() + menubarItem.position().top
      submenu.$domElement.css "left", menubarItem.position().left

