`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateDidEnter: ->
    @game.registerGameObject "Ship", Ship
    @game.spawn "Ship"

Ship = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform

    shipBody = new Two.RenderNode()
    shipBody.renderable = new Two.Path
      points: [[0,0], [0, 20], [40,0], [0,-20]]

    @components.transform.node.add shipBody
    @components.transform.node.position = [50, 100]

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState

new Two.Game(delegate: new GameDelegate()).start()
