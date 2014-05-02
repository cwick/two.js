`import Mixin from "mixin";`

describe "Mixin", ->
  it "can be created", ->
    Mixin.create()

  it "is instanceof Mixin", ->
    expect(Mixin.create() instanceof Mixin).toBe true

  it "can mix its properties into a base object", ->
    base = new Object()
    mixin = Mixin.create foo: "bar"

    mixin.apply base
    expect(base.foo).toEqual "bar"

  it "functions can access the base object's properties", ->
    base = { foo: "bar" }
    mixin = Mixin.create getFoo: -> @foo
    mixin.apply base
    expect(base.getFoo()).toEqual "bar"

  it "object values are shared between all instances", ->
    base1 = new Object()
    base2 = new Object()

    mixin = Mixin.create foo: [1,2,3]
    mixin.apply base1
    mixin.apply base2

    base1.foo.push("shared")
    expect(base2.foo.length).toEqual 4
    expect(base2.foo[3]).toEqual "shared"

  it "the 'initialize' property is not copied to the base object", ->
    base = new Object()
    mixin = Mixin.create initialize: ->
    mixin.apply base
    expect(base.initialize).toBeUndefined()

  it "property values can be initialized when the mixin is applied", ->
    base1 = new Object()
    base2 = new Object()

    mixin = Mixin.create
      initialize: ->
        @foo = [1,2,3]

    mixin.apply base1
    mixin.apply base2

    base1.foo.push("not shared")
    expect(base1.foo.length).toEqual 4
    expect(base2.foo.length).toEqual 3
