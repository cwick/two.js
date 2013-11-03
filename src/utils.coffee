define ->
  merge: (out={}, obj) ->
    out[k] = v for k,v of obj
    out
