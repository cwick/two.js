require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "signals": "../lib/signals"
    "uuid": "../lib/uuid"
    "two": "."

require ["editor/editor", "editor/main_toolbar"], (Editor, MainToolbar) ->
  editor = new Editor()

  toolbar = new MainToolbar(editor.on)

  $(".main-view").append toolbar.domElement
  $(".main-view").append editor.domElement
  editor.run()

