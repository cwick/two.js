class PeriodicSampler
  constructor: (@frequency) ->
    @samples = {}

  sample: (value, name="default") ->
    now = window.performance.now()

    @samples[name] ||= value: 0, time: 0

    if @_shouldSample(now, name)
      @samples[name] = value: value, time: now

    @samples[name].value

  _shouldSample: (now, name) ->
    !@frequency? || !@samples[name].value? || (now - @samples[name].time) > 1000/@frequency

class ProfilerInstance
  constructor: (@name, frequency) ->
    @sampler = new PeriodicSampler(frequency)

  collect: (fn) ->
    start = window.performance.now()
    fn()
    end = window.performance.now()

    @sampler.sample(end - start)

Profiler =  {
  measure: (frame, fn) ->
    if typeof(frame) == "function"
      fn = frame
      frame = "default"

    start = window.performance.now()
    fn()
    end = window.performance.now()

    @frames[frame] = (end - start).toFixed(0)

  incrementCounter: (name, amount=1) ->
    @counters[name] ||= 0
    @counters[name] += amount

  reset: ->
    @frames = {}
    @counters = {}

  counters: {}
  frames: {}
}

class Timer
  mark: ->
    now = window.performance.now()
    last = @lastMark || now
    @lastMark = now

    now - last

`export { PeriodicSampler, Profiler, Timer }`
