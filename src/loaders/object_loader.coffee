class ObjectLoader
  preload: (name, fullPath, resolve) ->
    xhr = new XMLHttpRequest()
    xhr.open "GET", fullPath, true
    xhr.onload = ->
      resolve(JSON.parse(xhr.responseText))
    xhr.send()

`export default ObjectLoader`
