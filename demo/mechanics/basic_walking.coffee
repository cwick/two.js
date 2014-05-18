# Inspired by http://gamemechanicexplorer.com/
`module Two from "two"`

Game = Two.Game.extend
  setup: ->
    @canvasSize = [848, 450]
    @renderer.backend.imageSmoothingEnabled = false

new Game().start()
