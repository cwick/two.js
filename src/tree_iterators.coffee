`import Property from "./property"`
`module Queue from "lib/queue"`

class DepthFirstTreeIterator
  constructor: (@root) ->

  execute: (callback) ->
    @_visit @root, callback

  _visit: (root, callback) ->
    callback(root)
    children = root.children
    @_visit node, callback for node in children if children?
    return

`export { DepthFirstTreeIterator }`
