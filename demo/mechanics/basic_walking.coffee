# Inspired by http://gamemechanicexplorer.com/
`module Two from "two"`

Game = Two.Game.extend
  setup: ->
    @canvas.width = 848
    @canvas.height = 450
    @renderer.backend.imageSmoothingEnabled = false

    @renderer.backgroundColor = "#4488cc"
    @camera.anchorPoint = [0,0]
    @camera.position.y = -32

    # Create a player sprite
    player = @scene.add new Two.TransformNode(position: [@canvas.width/2,0])
    playerSprite = new Two.Sprite
      image: "/demo/assets/player.png"
      anchorPoint: [0.5, 0]
    player.add(new Two.RenderNode(components: [playerSprite]))

    # Create some ground for the player to walk on
    ground = @scene.add new Two.TransformNode()
    groundSprite = new Two.Sprite(image: "/demo/assets/ground.png", anchorPoint: [0, 0])

    for x in [0...@canvas.width] by 32
      do (x) ->
        groundBlock = new Two.TransformNode(position: [x, -32])
        groundBlock.add new Two.RenderNode(components: [groundSprite])
        ground.add groundBlock

new Game().start()
