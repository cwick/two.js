# Inspired by http://gamemechanicexplorer.com/
`module Two from "two"`

Game = Two.Game.extend
  configure: ->
    @canvas.width = 848
    @canvas.height = 450

    @renderer.backgroundColor = "#4488cc"

    # Create some ground for the player to walk on
    ground = @scene.add new Two.TransformNode()
    groundSprite = new Two.Sprite(image: "/demo/assets/ground.png", anchorPoint: [0, 0])

    for x in [0...@canvas.width] by 32
      do (x) ->
        groundBlock = new Two.TransformNode(position: [x, 0])
        groundBlock.add new Two.RenderNode(renderable: groundSprite)
        ground.add groundBlock

    player = @spawn "Player"

game = new Game()

# Create the player entity
game.registerGameObject "Player", Two.GameObject.extend Two.Components.ArcadePhysics,
  MAX_SPEED: 500 # pixels / second
  ACCELERATION: 1500 # pixels / second / second

  initialize: ->
    playerSprite = new Two.Sprite
      image: "/demo/assets/player.png"
      anchorPoint: [0.5, 0]

    @transform.add new Two.RenderNode(renderable: playerSprite)

    # Make player collide with world boundaries so he doesn't leave the stage
    @physics.collideWorldBounds = true
    @physics.boundingBox.y = -16
    @physics.boundingBox.width = 32
    @physics.boundingBox.height = 32
    @physics.maxVelocity = [@MAX_SPEED, @MAX_SPEED]

  objectDidSpawn: ->
    @physics.position.x = @game.canvas.width/2
    @physics.position.y = 32

  tick: ->
    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.acceleration.x = -@ACCELERATION
    else if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.acceleration.x = @ACCELERATION
    else
      @physics.acceleration.x = 0
      @physics.velocity.x = 0


game.start()

