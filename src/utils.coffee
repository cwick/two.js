iterateThroughNestedArrays = (array, callback) ->
  for item in array
    if item instanceof Array
      iterateThroughNestedArrays(item, callback)
    else
      callback(item)

`export { iterateThroughNestedArrays }`
