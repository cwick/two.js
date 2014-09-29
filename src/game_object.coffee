`import TwoObject from "./object"`
`import Transform from "./components/transform"`

nextID = 1

GameObject = TwoObject.extend Transform,
  initialize: ->
    @id = nextID++

  spawn: ->
  tick: ->
  die: ->
    @game.remove @

`export default GameObject`
