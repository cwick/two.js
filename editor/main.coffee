require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "two": "."

require ["editor/editor"], (editor) ->
  editor.run()

