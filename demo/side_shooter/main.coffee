`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateDidEnter: ->
    @game.registerGameObject "Ship", Ship
    @game.spawn "Ship"

Ship = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics
    @addComponent Two.Components.PlayerMovement

    @initializeRenderable()
    @initializePhysics()

  initializePhysics: ->
    SPEED_MULTIPLIER = 60

    maxAcceleration = Math.pow SPEED_MULTIPLIER, 2
    maxVelocity = 4*SPEED_MULTIPLIER

    @physics.position.setValues [100, 100]
    @physics.boundingBox = @shipBody.boundingBox
    @physics.maxVelocity.setValues [maxVelocity, maxVelocity]
    @physics.drag.setValues [maxAcceleration/2, maxAcceleration/2]
    @components.movement.maxAcceleration.setValues [maxAcceleration, maxAcceleration]

  initializeRenderable: ->
    @shipBody = new Two.RenderNode()
    @shipBody.renderable = new Two.Path
      points: [[0,0], [0, 20], [40,0], [0,-20]]

    @transform.add @shipBody

  tick: ->
    inputVector = new Two.Vector2d()

    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      inputVector.x -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      inputVector.x += 1

    if @game.input.keyboard.isKeyDown Two.Keys.UP
      inputVector.y -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.DOWN
      inputVector.y += 1

    @addInputVector inputVector

    @super(Two.GameObject, "tick", arguments)

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState

new Two.Game(delegate: new GameDelegate()).start()
