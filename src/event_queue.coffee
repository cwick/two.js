`module Two from "two"`

class EventQueue
  constructor: ->
    @events = {}
    @currentTime = 0

  schedule: (delay, callback) ->
    time = delay + @currentTime

    @events[time] ||= []
    @events[time].push callback

  tick: (deltaSeconds) ->
    @currentTime += deltaSeconds

    for time, callbacks of @events
      if time <= @currentTime
        callback() for callback in callbacks
        delete @events[time]

    return

`export default EventQueue`

