`import Property from "./property"`

class BreadthFirstTreeIterator
  constructor: (root) ->
    @_queue = []
    @_queue.push root if root?

  hasNext: Property
    get: -> @_queue.length > 0

  next: ->
    node = @_queue.pop() || null
    @_queue.unshift(child) for child in node.children if node?.children?
    node

Property.setupProperties BreadthFirstTreeIterator.prototype

`export { BreadthFirstTreeIterator }`
