`import Mixin from "../mixin"`

Physics = Mixin.create
  initialize: ->
    @physics =
      velocity: [0,0]

`export default Physics`
