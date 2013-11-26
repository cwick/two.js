require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "signals": "../lib/signals"
    "two": "."

require ["editor/editor"], (Editor) ->
  editor = new Editor()

  $(".main-view").append editor.domElement
  editor.run()

