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
  create: (name, frequency) -> new ProfilerInstance(name, frequency)
}

class Timer
  mark: ->
    now = window.performance.now()
    last = @lastMark || now
    @lastMark = now

    now - last

`export { PeriodicSampler, Profiler, Timer }`
