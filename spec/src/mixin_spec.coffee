`import Mixin from "mixin"`
`import Property from "property"`

describe "Mixin", ->
  it "can be created", ->
    Mixin.create()

  it "is instanceof Mixin", ->
    expect(Mixin.create() instanceof Mixin).toBe true

  it "can detect if mixed into a base object", ->
    base = new Object()
    FooMixin = Mixin.create foo: "bar"
    FooMixin.apply base

    expect(FooMixin.detect base).toBe true

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

  it "the mixin initializer sets properties on the base object", ->
    base = new Object()

    mixin = Mixin.create
      initialize: ->
        @foo = "hello"

    mixin.apply base

    expect(base.foo).toEqual "hello"

  describe "defining properties", ->
    it "can mix in a property", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property get: -> "hello"

      mixin.apply base

      expect(base.foo).toEqual "hello"

    it "can access a base object variable from a default getter", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property()

      mixin.apply base
      base._foo = "hello"
      expect(base.foo).toEqual "hello"

    it "can access a base object variable from a custom getter", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property get: -> @_foo

      mixin.apply base
      base._foo = "hello"
      expect(base.foo).toEqual "hello"

    it "the initializer is called after properties are defined", ->
      base = new Object()
      mixin = Mixin.create
       initialize: -> @readonly = 123
       readonly: Property readonly: true

      expect(-> mixin.apply base).toThrow()





