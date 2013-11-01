require.config
  paths:
    jquery: "../../lib/jquery-2.0.3"
    "jquery.mousewheel": "../../lib/jquery.mousewheel"

require ["editor"], (editor) ->
  editor.run()

