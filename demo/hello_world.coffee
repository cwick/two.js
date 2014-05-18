`module Two from "two"`

Game = Two.Game.extend
  setup: ->
    @canvasSize = [640, 480]

  update: ->
    helloWorldTransform.rotation += 0.008
    wobble.position.x = Math.sin(Date.now() / 500) * 100

game = new Game()

wobble = new Two.TransformNode()
helloWorldTransform = new Two.TransformNode()
worldTransform = new Two.TransformNode()
helloTransform = new Two.TransformNode()

helloWorldTransform.scale = .5

helloTransform.add new Two.RenderNode()
helloTransform.children[0].add new Two.Sprite
  image: "https://upload.wikimedia.org/wikipedia/en/6/65/Hello_logo_sm.gif"
  anchorPoint: [0, 1]
worldTransform.add new Two.RenderNode()
worldTransform.children[0].add new Two.Sprite
  image: "http://img.talkandroid.com/uploads/2012/08/World-300x305.jpg"
  anchorPoint: [0, 1]

helloTransform.position = [-305, 150]
worldTransform.position = [0, 150]

game.scene.add wobble

wobble.add helloWorldTransform
helloWorldTransform.add helloTransform
helloWorldTransform.add worldTransform

game.start()

