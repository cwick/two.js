`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateWillEnter: ->

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    @super(Two.DefaultGameDelegate, "gameDidInitialize", arguments)

    game.registerState "main", MainState

new Two.Game(delegate: new GameDelegate()).start()
