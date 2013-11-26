define ->
  setTranslation: (e, x, y) ->
    e.css("-webkit-transform": "translate3d(#{Math.round(x)}px,#{Math.round(y)}px,0)")

  getTranslation: (e) ->
    transform = e.attr("style")
    match = /translate3d\((\d+)px, (\d+)px/.exec(transform)

    if match?
      [parseFloat(match[1]), parseFloat(match[2])]
    else
      [0,0]
