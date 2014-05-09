`import Property from "./property"`
`module Queue from "lib/queue"`

class BreadthFirstTreeIterator
  constructor: (root) ->
    @_queue = new Queue()
    @_queue.enqueue root if root?

  hasNext: Property
    get: -> !@_queue.isEmpty()

  next: ->
    node = @_queue.dequeue() || null
    @_queue.enqueue(child) for child in node.children if node?.children?

    node

Property.setupProperties BreadthFirstTreeIterator.prototype

`export { BreadthFirstTreeIterator }`
