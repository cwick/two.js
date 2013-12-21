define (require) ->
  Editor = require "./editor"
  MainToolbar = require "./main_toolbar"
  MainMenubar = require "./main_menubar"

  class MainEditorView
    constructor: ->
      @editor = new Editor()

      menubar = new MainMenubar(@editor.on)
      toolbar = new MainToolbar(@editor.on)

      $("body").append """
        <div id="editor" class="panel-vertical">
          <div class="panel main-view">
          </div>
        </div>
      """

      $("#editor").prepend menubar.domElement
      $(".main-view").append toolbar.domElement
      $(".main-view").append @editor.domElement

    run: ->
      @editor.run()

