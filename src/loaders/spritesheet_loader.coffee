class SpritesheetLoader
  preload: (name, fullPath, resolve) ->
    image = @assetLoader.preloadImage("#{name}.png")
    frames = @assetLoader.preloadJSON("#{name}.json")
    Promise.all([image, frames]).then ->
      resolve(hello: "world")

`export default SpritesheetLoader`


