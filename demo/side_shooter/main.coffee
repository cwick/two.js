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

    shipBody = new Two.RenderNode()
    shipBody.renderable = new Two.Path
      points: [[0,0], [0, 20], [40,0], [0,-20]]

    @transform.add shipBody
    @physics.position.setValues [0, 100]
    @physics.boundingBox = shipBody.boundingBox

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState
    game.world.physics.arcade.gravity.setValues [0, 100]

new Two.Game(delegate: new GameDelegate()).start()
