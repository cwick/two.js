define ["jquery", "./lib/menubar", "./lib/submenu", "./lib/menu_item"], ($, Menubar, Submenu, MenuItem) ->
  class MainMenubar extends Menubar
    constructor: (@_signals) ->
      super

      fileMenu = new Submenu(name: "File")
      fileMenu.addItem new MenuItem(name: "New Project")
      fileMenu.addItem new MenuItem(name: "Open Project...")

      editMenu = new Submenu(name: "Edit")
      editMenu.addItem new MenuItem(name: "Undo")
      editMenu.addItem new MenuItem(name: "Redo")

      viewMenu = new Submenu(name: "View")
      viewMenu.addItem new MenuItem(name: "Show grid")
      viewMenu.addItem new MenuItem(name: "Snap to grid")

      @addItem fileMenu
      @addItem editMenu
      @addItem viewMenu
