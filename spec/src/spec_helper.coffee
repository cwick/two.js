`import Vector2d from "vector2d"`

# So pretty printing works
Float32Array.prototype.jasmineToString = ->
  result = []
  result.push value for value in @
  "[#{result.join ", "}]"

Float32ArrayEqualityTester = (first, second) ->
  if first instanceof Float32Array && second instanceof Float32Array ||
     first instanceof Array && second instanceof Float32Array ||
     first instanceof Float32Array && second instanceof Array

    return false unless first.length == second.length
    for i in [0..first.length-1]
      return false unless getJasmineRequireObj().toBeCloseTo()().compare(first[i], second[i]).pass

    return true
  else
    return undefined

Vector2dEqualityTester = (first, second) ->
  if first instanceof Vector2d && second instanceof Array
    return false unless first.length == second.length
    for v,i in first
      return false unless getJasmineRequireObj().toBeCloseTo()().compare(v, second[i]).pass
    return true
  else
    return undefined

beforeEach ->
  jasmine.addCustomEqualityTester(Float32ArrayEqualityTester)
  jasmine.addCustomEqualityTester(Vector2dEqualityTester)

