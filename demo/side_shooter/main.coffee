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

    shipBody = new Two.RenderNode()
    shipBody.renderable = new Two.Path
      points: [[0,0], [0, 20], [40,0], [0,-20]]

    @transform.add shipBody
    @physics.position.setValues [100, 100]
    @physics.boundingBox = shipBody.boundingBox
    @physics.maxVelocity.setValues [500, 500]
    @physics.drag.setValues [5000, 5000]
    @components.movement.maxAcceleration.setValues [10000, 10000]

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
