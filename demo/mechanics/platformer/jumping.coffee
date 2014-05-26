# Inspired by http://gamemechanicexplorer.com/
`module Two from "two"`

Game = Two.Game.extend
  GRAVITY: -2600 # pixels / second / second

  configure: ->
    @canvas.width = 848
    @canvas.height = 450
    @renderer.backend.imageSmoothingEnabled = false
    @renderer.backgroundColor = "#4488cc"
    @world.physics.arcade.gravity.y = @GRAVITY

    # Create some ground for the player to walk on
    ground = @scene.add new Two.TransformNode()
    groundSprite = new Two.Sprite(image: "/demo/assets/ground.png", anchorPoint: [0, 0])

    for x in [0...@canvas.width] by 32
      do (x) ->
        groundBlock = new Two.TransformNode(position: [x, 0])
        groundBlock.add new Two.RenderNode(elements: [groundSprite])
        ground.add groundBlock

    @scene.add @drawHeightMarkers()
    @spawn "Player"

  drawHeightMarkers: ->
    markers = new Two.TransformNode()
    sprite = new Two.Sprite
      image: Two.Canvas.create(devicePixelRatio: 1, width: @canvas.width, height: @canvas.height).domElement
      anchorPoint: [0, 0]
    markers.add new Two.RenderNode(elements: [sprite])

    context = sprite.image.getContext "2d"

    for y in [@canvas.height - 32..64] by -32
      context.beginPath()
      context.strokeStyle = 'rgba(255, 255, 255, 0.2)'
      context.moveTo(0, y)
      context.lineTo(sprite.image.width, y)
      context.stroke()

    markers

game = new Game()

# Create the player entity
game.registerEntity "Player", Two.GameObject.extend Two.Components.ArcadePhysics,
  MAX_SPEED: 500 # pixels / second
  JUMP_SPEED: 1000 # pixels / second
  ACCELERATION: 1500 # pixels / second / second
  DRAG: 600 # pixels / second

  initialize: ->
    playerSprite = new Two.Sprite
      image: "/demo/assets/player.png"
      anchorPoint: [0.5, 0]

    @transform.add new Two.RenderNode(elements: [playerSprite])

    # Make player collide with world boundaries so he doesn't leave the stage
    @physics.collideWorldBounds = true
    @physics.boundingBox.y = -16
    @physics.boundingBox.width = 32
    @physics.boundingBox.height = 32
    @physics.maxVelocity = [@MAX_SPEED, @MAX_SPEED * 10]
    # Add drag to the player that slows them down when they are not accelerating
    @physics.drag.x = @DRAG

  spawn: ->
    @physics.position.x = @game.canvas.width/2
    @physics.position.y = 32

  update: ->
    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.acceleration.x = -@ACCELERATION
    else if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.acceleration.x = @ACCELERATION
    else
      @physics.acceleration.x = 0

    if @game.input.keyboard.isKeyDown(Two.Keys.UP) && @physics.touching.down
      @physics.velocity.y = @JUMP_SPEED

game.start()



