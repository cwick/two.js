`import Sprite from "../sprite"`

class SpritesheetLoader
  preload: (name, fullPath, resolve) ->
    imagePromise = @assetLoader.preloadImage("#{name}.png")
    framesPromise = @assetLoader.preloadJSON("#{name}.json")

    Promise.all([imagePromise, framesPromise]).then (results) =>
      image = results[0]
      frames = results[1].frames
      resolve(@createSpritesheet(image, frames))

  createSpritesheet: (image, frames) ->
    sprite = new Sprite(image: image)

    for name of frames
      frame = frames[name].frame
      sprite.addFrame name, x: frame.x, y: frame.y, width: frame.w, height: frame.h

    sprite

`export default SpritesheetLoader`


