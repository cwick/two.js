class Debug
  constructor: ->
    @_previousTimestamp = 0
    @_previousFrameTime = 0
    @fps = 0
    @frameTime = 0

  _calcFrameTime: (timestamp) ->
    return unless timestamp? && @_previousTimestamp?

    weight = .4

    @frameTime = timestamp - @_previousTimestamp
    @frameTime = (@frameTime * weight) + (@_previousFrameTime * (1 - weight))

    @_previousFrameTime = @frameTime
    @_previousTimestamp = timestamp

    @fps = Math.round(1/@frameTime * 1000)


`export default Debug`
