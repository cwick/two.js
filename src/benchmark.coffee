class PeriodicSampler
  constructor: (@frequency) ->

  sample: (value) ->
    now = window.performance.now()

    if @_shouldSample(now)
      @lastSample = value
      @lastSampleTime = now

    @lastSample

  _shouldSample: (now) ->
    !@frequency? || !@lastSample? || (now - @lastSampleTime) > 1000/@frequency

class ProfilerInstance
  constructor: (@name, frequency) ->
    @sampler = new PeriodicSampler(frequency)

  collect: (fn) ->
    start = window.performance.now()
    fn()
    end = window.performance.now()

    @sampler.sample(end - start)

Profiler =  {
  create: (name, frequency) -> new ProfilerInstance(name, frequency)
}

class Timer
  mark: ->
    now = window.performance.now()
    last = @lastMark || now
    @lastMark = now

    now - last

`export { PeriodicSampler, Profiler, Timer }`
