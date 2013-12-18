define ["jquery", "./lib/menubar", "./lib/submenu", "./lib/menu_item"], ($, Menubar, Submenu, MenuItem) ->
  class MainMenubar extends Menubar
    constructor: (@_signals) ->
      super

      fileMenu = new Submenu(name: "File")
      fileMenu.addItem new MenuItem(name: "New Project")
      fileMenu.addItem( new MenuItem(name: "Open Project...")).selected.add =>
        @_signals.projectOpened.dispatch()

      editMenu = new Submenu(name: "Edit")
      editMenu.addItem new MenuItem(name: "Undo")
      editMenu.addItem new MenuItem(name: "Redo")
      editMenu.addItem new MenuItem(name: "Undo")
      editMenu.addItem new MenuItem(name: "Undo")
      editMenu.addItem new MenuItem(name: "Undo asdkjfhkajsdhf aksdjhf askjf kdshjakf")
      editMenu.addItem new MenuItem(name: "Undo")
      editMenu.addItem new MenuItem(name: "Redo")
      editMenu.addItem new MenuItem(name: "Redo")
      editMenu.addItem new MenuItem(name: "Redo")
      editMenu.addItem new MenuItem(name: "Redo")

      viewMenu = new Submenu(name: "View")

      @showGrid = viewMenu.addItem(new MenuItem(name: "Show grid", isCheckable: true))
      @showGrid.selected.add (item) =>
        @_signals.gridChanged.dispatch(isVisible: item.isChecked())

      @snapToGrid = viewMenu.addItem(new MenuItem(name: "Snap to grid", isCheckable: true))
      @snapToGrid.selected.add (item) =>
        @_signals.gridSnappingChanged.dispatch(item.isChecked())

      @addItem fileMenu
      @addItem editMenu
      @addItem viewMenu

      @_signals.gridChanged.add @_onGridChanged, @
      @_signals.gridSnappingChanged.add @_onGridSnappingChanged, @

    _onGridChanged: (e) ->
      if e.isVisible then @showGrid.check() else @showGrid.uncheck()
      return true

    _onGridSnappingChanged: (isEnabled) ->
      if isEnabled then @snapToGrid.check() else @snapToGrid.uncheck()
      return true
