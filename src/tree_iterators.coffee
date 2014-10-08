`import Property from "./property"`

class DefaultTreeIteratorDelegate
  shouldIterationContinue: -> true
  visitNode: ->

class DepthFirstTreeIterator
  constructor: (@root) ->

  execute: (delegate = new DefaultTreeIteratorDelegate()) ->
    @_visit @root, delegate

  _visit: (root, delegate) ->
    if delegate.shouldIterationContinue(root)
      delegate.visitNode(root)
      children = root._children
      @_visit node, delegate for node in children if children?

    return

`export { DepthFirstTreeIterator }`
