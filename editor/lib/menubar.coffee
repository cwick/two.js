define ["jquery", "./control"], ($, Control) ->
  class Menubar extends Control
    constructor: (options) ->
      super $("<ul/>", class: "menubar")

      $(document).mousedown (e) =>
        @close()

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

    deactivate: (item) ->
      item.removeClass "active"
      $("body").find(".submenu").detach()

    close: ->
      $("body").find(".submenu").detach()
      @$domElement.children(".active").removeClass "active"

    _bindMenuItemEventHandlers: (item) ->
      item.mousedown (e) =>
        e.stopPropagation()

        if item.hasClass "active"
          @deactivate item
        else
          @activate item

      item.mouseenter =>
        @activate(item) if item.siblings(".active").length > 0

    _openSubmenu: (menubarItem, submenu) ->
      $("body").find(".submenu").detach()
      $("body").append submenu.$domElement
      submenu.$domElement.css "top", menubarItem.outerHeight() + menubarItem.position().top
      submenu.$domElement.css "left", menubarItem.position().left

