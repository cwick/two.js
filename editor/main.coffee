require.config
  paths:
    jquery: "../../lib/jquery-2.0.3"
    "jquery.mousewheel": "../../lib/jquery.mousewheel"
    "gl-matrix": "../../lib/gl-matrix"

require ["editor"], (editor) ->
  editor.run()

