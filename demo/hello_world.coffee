`module Two from "two"`


MainState = Two.GameState.extend
  stateDidEnter: ->
    hello = @game.spawn "HelloWorld", name: "HelloWorld"

  stateWillTick: (deltaSeconds) ->
    helloObject = @game.world.findByName("HelloWorld")
    helloObject.transform.position.x = Math.sin(Date.now() / 500) * 100
    helloObject.transform.rotation += 0.008

HelloWorld = new Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform

    worldTransform = new Two.TransformNode()
    helloTransform = new Two.TransformNode()

    helloTransform.add new Two.RenderNode(renderable: new Two.Sprite
      image: "/demo/assets/hello.gif"
      anchorPoint: [0, 1])

    worldTransform.add new Two.RenderNode(renderable: new Two.Sprite
      image: "/demo/assets/world.jpg"
      anchorPoint: [0, 1])

    helloTransform.position = [-305, 150]
    worldTransform.position = [0, 150]

    @transform.add helloTransform
    @transform.add worldTransform
    @transform.scale = .5

GameDelegate = Two.DefaultGameDelegate.extend
  gameWillInitialize: (game) ->
    game.registerState "main", MainState
    game.registerGameObject "HelloWorld", HelloWorld

  gameDidInitialize: (game) ->
    game.camera.anchorPoint = [0.5, 0.5]
    game.renderer.backend.flipYAxis = true

game = new Two.Game(delegate: new GameDelegate())

game.start()

