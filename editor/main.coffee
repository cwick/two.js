require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "signals": "../lib/signals"
    "uuid": "../lib/uuid"
    "two": "."

require ["editor/editor", "editor/main_toolbar", "editor/main_menubar"], \
        (Editor, MainToolbar, MainMenubar) ->
  editor = new Editor()

  menubar = new MainMenubar(editor.on)
  toolbar = new MainToolbar(editor.on)


  $("#editor").prepend menubar.domElement
  $(".main-view").append toolbar.domElement
  $(".main-view").append editor.domElement
  editor.run()

