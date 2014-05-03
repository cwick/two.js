`import CanHaveParent from "can_have_parent"`
`import TwoObject from "object"`

describe "CanHaveParent", ->
  beforeEach ->
    @child = TwoObject.createWithMixins CanHaveParent

  it "can have a parent", ->
    @child._setParent(123)
    expect(@child.parent).toEqual 123

  it "has no parent by default", ->
    expect(@child.parent).toBeNull()

