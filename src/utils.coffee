define ->
  merge: (out={}, obj) ->
    out[k] = v for k,v of obj
    out

  vectorEquals: (v1, v2) -> v1[0] == v2[0] && v1[1] == v2[1]
