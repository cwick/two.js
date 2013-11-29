define ["jquery", "./lib/toolbar"], ($, Toolbar) ->
  class MainToolbar extends Toolbar
    constructor: (@_signals) ->
      super orientation: "vertical"

      @_signals.toolSelected.add @_onToolSelected, @

      @_addTool(t[0], t[1]) for t in [
        ["select", "pointer"],
        ["zoom"],
        ["grab", "hand"],
        ["stamp"]]

    _onToolSelected: (which) ->
      item = @$domElement.find "##{which}-tool"
      @activate item

    _addTool: (name, icon=name) ->
      tool = @addItem($("<button/>", id: "#{name}-tool", class: "icon icon-#{icon}"))
      tool.click => @_signals.toolSelected.dispatch name

