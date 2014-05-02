`import Mixin from "./mixin"`
`import Property from "./property"`

Hierarchical = Mixin.create
  children: Property readonly: true
  parent: Property readonly: true

  add: (child) ->

`export default Hierarchical`
