`module Two from "two"`

MainState = Two.GameState.extend
  stateWillTick: (deltaSeconds) ->
    helloWorldTransform.rotation += 0.008
    wobble.position.x = Math.sin(Date.now() / 500) * 100

game = new Two.Game()
game.camera.anchorPoint = [0.5, 0.5]

wobble = new Two.TransformNode()
helloWorldTransform = new Two.TransformNode()
worldTransform = new Two.TransformNode()
helloTransform = new Two.TransformNode()

helloWorldTransform.scale = .5

helloTransform.add new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/hello.gif"
  anchorPoint: [0, 1])

worldTransform.add new Two.RenderNode(renderable: new Two.Sprite
  image: "/demo/assets/world.jpg"
  anchorPoint: [0, 1])

helloTransform.position = [-305, 150]
worldTransform.position = [0, 150]

game.scene.add wobble

wobble.add helloWorldTransform
helloWorldTransform.add helloTransform
helloWorldTransform.add worldTransform

game.registerState "main", MainState
game.start()

