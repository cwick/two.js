`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateWillEnter: ->

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState

    game.scene.add new Two.RenderNode(renderable: new Two.Text(text: "hello world!"))
    game.scene.position = [0,40]

new Two.Game(delegate: new GameDelegate()).start()
