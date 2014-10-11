`module Two from "two"`
`module p2 from "lib/p2"`

Ball = new Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.P2Physics
    @addComponent Two.Components.Transform

    @width = @height = 20

    @initializeRenderable()
    @initializePhysics()

  initializeRenderable: ->
    ballSprite = new Two.Sprite
      image: "/demo/assets/soccer_ball.png"
      crop: new Two.Rectangle
        x: 5
        y: 5
        width: 470
        height: 470

    @transform.add new Two.RenderNode renderable: ballSprite, width: @width, height: @height

  initializePhysics: ->
    @physics.motionState = p2.Body.DYNAMIC
    @physics.mass = 1
    @physics.velocity[0] = (Math.random() - .5) * 300
    @physics.velocity[1] = Math.random() * - 400 + 100
    @physics.angularVelocity = (Math.random() - .5) * 2*Math.PI
    @physics.addShape new p2.Circle(@width/2)
    @physics.updateMassProperties()

  prepareToSpawn: ->
    @physics.position = @_getRandomPosition()

  _getRandomPosition: ->
    [
      Math.random() * (@game.canvas.width - @width) + @width/2,
      Math.random() * (@game.canvas.height - @height) + @height/2
    ]

Boundary = Two.GameObject.extend
  initialize: (options) ->
    @addComponent Two.Components.P2Physics
    @addComponent Two.Components.Transform
    @physics.addShape(new p2.Plane())

  type: Two.Property
    set: (value) ->
      switch value
        when "bottom"
          @physics.position[1] = 0
          @physics.angle = 0
        when "left"
          @physics.angle = -Math.PI/2
        when "right"
          @physics.angle = Math.PI/2
          @physics.position[0] = @game.canvas.width
        when "top"
          @physics.position[1] = @game.canvas.height
          @physics.angle = Math.PI

MainState = Two.GameState.extend
  stateDidEnter: ->
    BALL_COUNT = 15*10
    @game.spawn "Ball" for _ in [1..BALL_COUNT]
    @game.spawn("Boundary").type = "top"
    @game.spawn("Boundary").type = "bottom"
    @game.spawn("Boundary").type = "left"
    @game.spawn("Boundary").type = "right"

  stateWillTick: (deltaSeconds) ->

GameDelegate = Two.DefaultGameDelegate.extend
  gameWillInitialize: (game) ->
    game.registerState "main", MainState
    game.registerGameObject "Ball", Ball
    game.registerGameObject "Boundary", Boundary

  gameDidInitialize: (game) ->
    game.renderer.backend.flipYAxis = true
    world = game.world.physics.p2.p2World

    world.gravity = [0, -920]
    world.defaultContactMaterial.restitution = .55
    world.defaultContactMaterial.stiffness = Number.MAX_VALUE

game = new Two.Game(delegate: new GameDelegate())

game.start()

