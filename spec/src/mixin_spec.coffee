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
    mixin = Mixin.create getFoo: -> @_base.foo
    mixin.apply base
    expect(base.getFoo()).toEqual "bar"

  it "functions set instance variables in a private context", ->
    base = { foo: "bar" }
    mixin = Mixin.create
      setPrivateFoo: (value) -> @foo = value
      getPrivateFoo: -> @foo

    mixin.apply base
    base.setPrivateFoo("private")
    expect(base.foo).toEqual "bar"
    expect(base.getPrivateFoo()).toEqual "private"

  it "the same mixin applied to different objects does not share private context", ->
    base1 = new Object()
    base2 = new Object()
    mixin = Mixin.create
      setPrivateFoo: (value) -> @foo = value
      getPrivateFoo: -> @foo

    mixin.apply base1
    mixin.apply base2

    base1.setPrivateFoo("private1")
    base2.setPrivateFoo("private2")

    expect(base1.getPrivateFoo()).toEqual "private1"
    expect(base2.getPrivateFoo()).toEqual "private2"

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

  it "the mixin initializer sets properties in a private context by default", ->
    base = new Object()

    mixin = Mixin.create
      initialize: ->
        @foo = "hello"

    mixin.apply base

    expect(base.foo).toBeUndefined()

  it "property values on the base object can be initialized when the mixin is applied", ->
    base1 = new Object()
    base2 = new Object()

    mixin = Mixin.create
      initialize: ->
        @_base.foo = [1,2,3]

    mixin.apply base1
    mixin.apply base2

    base1.foo.push("not shared")
    expect(base1.foo.length).toEqual 4
    expect(base2.foo.length).toEqual 3

  describe "defining properties", ->
    it "can mix in a property", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property get: -> "hello"

      mixin.apply base

      expect(base.foo).toEqual "hello"

    it "uses the private context to store property values", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property()

      mixin.apply base
      base.foo = "hello"

      expect(base.foo).toEqual "hello"
      expect(base._foo).toBeUndefined()

    it "uses the private context to store read-only property values", ->
      base = new Object()

      mixin = Mixin.create
        foo: Property readonly: true
        setFoo: (value) -> @_foo = value

      mixin.apply base
      base.setFoo "hello"
      base._foo = "world"

      expect(base.foo).toEqual "hello"
      expect(base._foo).toEqual "world"

    it "uses the private context for custom getters", ->
      base = new Object()

      mixin = Mixin.create
        initialize: -> @_foo = "hello"
        foo: Property get: -> @_foo

      mixin.apply base
      base._foo = "world"
      expect(base.foo).toEqual "hello"

    it "the initializer is called after properties are defined", ->
      base = new Object()
      mixin = Mixin.create
       initialize: -> @_base.readonly = 123
       readonly: Property readonly: true

      expect(-> mixin.apply base).toThrow()





