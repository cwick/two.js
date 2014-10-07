console = window.console

Log = {}

Log.warning = (message) ->
  console.warn(message)

Log.debug = (message) ->
  console.debug(message)

Log.error = (message) ->
  console.error(message)

`export default Log`
