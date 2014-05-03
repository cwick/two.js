# So pretty printing works
Float32Array.prototype.jasmineToString = ->
  result = []
  result.push value for value in @
  "[#{result.join ", "}]"

Float32ArrayEqualityTester = (first, second) ->
  if first instanceof Float32Array && second instanceof Float32Array
    return false unless first.length == second.length
    for i in [0..first.length-1]
      return false unless getJasmineRequireObj().toBeCloseTo()().compare(first[i], second[i]).pass

    return true
  else
    return undefined


beforeEach ->
  jasmine.addCustomEqualityTester(Float32ArrayEqualityTester)

