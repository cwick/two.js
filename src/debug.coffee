`import { Profiler } from "./benchmark"`

class Debug
  constructor: ->
    @_previousTimestamp = 0
    @_previousFrameTime = 0
    @fps = 0
    @frameTime = {
      logic: 0
      render: 0
      physics: 0
      total: 0
    }

    @callCounter = {
      drawImage: 0
    }

  _updateStatistics: ->
    @frameTime.total = Profiler.frames["mainLoop"]
    @frameTime.logic = Profiler.frames["logic"]
    @frameTime.render = Profiler.frames["render"]
    @frameTime.physics = 0
    @callCounter.drawImage = Profiler.counters["drawImage"]

  _updateFramesPerSecond: (timestamp) ->
    return unless timestamp? && @_previousTimestamp?

    weight = .4

    frameTime = timestamp - @_previousTimestamp
    frameTime = (frameTime * weight) + (@_previousFrameTime * (1 - weight))

    @_previousFrameTime = frameTime
    @_previousTimestamp = timestamp

    @fps = Math.round(1/frameTime * 1000)


`export default Debug`
