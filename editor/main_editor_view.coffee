define (require) ->
  Control = require "./lib/control"
  Editor = require "./editor"
  MainToolbar = require "./main_toolbar"
  MainMenubar = require "./main_menubar"

  class MainEditorView extends Control
    constructor: ->
      super
      @$domElement.attr "id", "editor"
      @$domElement.addClass "panel-vertical"
      @$domElement.append $("<div/>", class: "panel main-view")

      editor = new Editor()
      menubar = new MainMenubar(editor.on)
      toolbar = new MainToolbar(editor.on)

      @$domElement.prepend menubar.domElement
      @$domElement.find(".main-view").append toolbar.domElement
      @$domElement.find(".main-view").append editor.domElement

      window.setTimeout (-> editor.resizeCanvas()), 0

