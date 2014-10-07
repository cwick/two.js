`module Two from "two"`

MainState = Two.GameState.extend
  stateWillPreloadAssets: ->
  stateWillEnter: ->

GameDelegate = Two.DefaultGameDelegate.extend
  gameDidInitialize: (game) ->
    Two.DefaultGameDelegate.prototype.gameDidInitialize.apply @, arguments

    game.registerState "main", MainState

new Two.Game(delegate: new GameDelegate()).start()
