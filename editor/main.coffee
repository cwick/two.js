require.config
  paths:
    jquery: '../lib/jquery-2.0.3'

require ["editor"], (editor) ->
  editor.run()

