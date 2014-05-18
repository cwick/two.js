# Inspired by http://gamemechanicexplorer.com/
`module Two from "two"`
`module p2 from "lib/p2"`

MAX_SPEED = 500 # pixels / second

Game = Two.Game.extend
  configure: ->
    @canvas.width = 848
    @canvas.height = 450
    @renderer.backend.imageSmoothingEnabled = false

    @renderer.backgroundColor = "#4488cc"
    @camera.anchorPoint = [0,0]
    @camera.position.y = -32

    # Create some ground for the player to walk on
    ground = @scene.add new Two.TransformNode()
    groundSprite = new Two.Sprite(image: "/demo/assets/ground.png", anchorPoint: [0, 0])

    for x in [0...@canvas.width] by 32
      do (x) ->
        groundBlock = new Two.TransformNode(position: [x, -32])
        groundBlock.add new Two.RenderNode(components: [groundSprite])
        ground.add groundBlock

    player = @spawn "Player"

game = new Game()

# Create the player entity
game.registerEntity "Player", Two.GameObject.extend Two.Components.RigidBody,
  initialize: ->
    @rigidBody.motionState = p2.Body.KINEMATIC
    @rigidBody.addShape new p2.Rectangle(32, 32)

    playerSprite = new Two.Sprite
      image: "/demo/assets/player.png"
      anchorPoint: [0.5, 0]

    @transform.add new Two.RenderNode(components: [playerSprite])

  spawn: ->
    @transform.position.x = @game.canvas.width/2

  update: ->
    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @rigidBody.velocity = [-MAX_SPEED, 0]
    else if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @rigidBody.velocity = [MAX_SPEED, 0]
    else
      @rigidBody.velocity = [0, 0]


game.start()
