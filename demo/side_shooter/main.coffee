`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateWillEnter: ->
    @game.registerGameObject "Ship", Ship

Ship = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState

    ship = new Two.TransformNode(position: [50,100])
    shipBody = ship.add new Two.RenderNode()
    shipBody.renderable = new Two.Path
      points: [[0,0], [0, 20], [40,0], [0,-20]]

    game.scene.add ship

new Two.Game(delegate: new GameDelegate()).start()
