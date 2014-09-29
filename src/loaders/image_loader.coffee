class ImageLoader
  preload: (name, fullPath, resolve) ->
    image = new Image()
    image.src = fullPath

    # TO INVESTIGATE: performance can be greater if Image is copied into a Canvas
    # first. But doing so can also make drawImage performance many times
    # slower, depending on platform.
    image.onload = ->
      resolve(image)

`export default ImageLoader`

