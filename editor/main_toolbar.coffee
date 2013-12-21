define ["jquery", "./lib/toolbar"], ($, Toolbar) ->
  class MainToolbar extends Toolbar
    constructor: (@_signals) ->
      super orientation: "vertical"

      @_signals.toolSelected.add @_onToolSelected, @

      @_addTool "select", "pointer"
      @_addTool "zoom"
      @_addTool "grab", "hand"

      @addItem $("<div/>", class: "toolbar-divider")

      @_addTool "stamp"
      @_addTool "erase", "eraser"

    _onToolSelected: (which) ->
      item = @$domElement.find "##{which}-tool"
      @activate item

    _addTool: (name, icon=name) ->
      tool = @addItem($("<div/>", id: "#{name}-tool", class: "icon icon-#{icon}"))
      tool.click => @_signals.toolSelected.dispatch name

