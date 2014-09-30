`module Two from "two"`

class EventQueue
  constructor: ->
    @timeEvents = {}
    @frameEvents = {}
    @currentTime = 0
    @currentFrame = 0

  schedule: (delay, callback) ->
    time = delay + @currentTime

    @timeEvents[time] ||= []
    @timeEvents[time].push callback

  frameDelay: (frameCount, callback) ->
    frame = frameCount + @currentFrame

    @frameEvents[frame] ||= []
    @frameEvents[frame].push callback


  tick: (deltaSeconds) ->
    @currentFrame += 1
    @currentTime += deltaSeconds

    @fireFrameEvents()
    @fireTimeEvents()

  fireTimeEvents: ->
    for time, callbacks of @timeEvents
      if time <= @currentTime
        callback() for callback in callbacks
        delete @timeEvents[time]

  fireFrameEvents: ->
    for frame, callbacks of @frameEvents
      if frame == @currentFrame.toString()
        callback() for callback in callbacks
        delete @frameEvents[frame]

    return

`export default EventQueue`

