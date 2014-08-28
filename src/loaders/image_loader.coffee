class ImageLoader
  preload: (name, fullPath, resolve) ->
    canvas = document.createElement "canvas"

    image = new Image()
    image.src = fullPath

    # In Chrome for Mac, drawing an image from a canvas is much
    # faster than drawing from an Image object
    image.onload = ->
      canvas.width = image.width
      canvas.height = image.height
      context = canvas.getContext "2d"
      context.drawImage image, 0,0
      resolve(canvas)

`export default ImageLoader`

