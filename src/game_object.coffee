`import TwoObject from "./object"`
`import Transform from "./components/transform"`

GameObject = TwoObject.extend Transform,
  initialize: ->
  spawn: ->
  update: ->
  die: ->
    @game.remove @

`export default GameObject`
