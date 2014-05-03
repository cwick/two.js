`import Property from "property";`
`import TwoObject from "object";`

describe "Property", ->
  it "when using #create, can have a getter", ->
    obj = TwoObject.create
      foo: Property
        get: -> "hello"

    expect(obj.foo).toEqual "hello"

  it "when using 'new', can have a getter", ->
    obj = new TwoObject
      foo: Property
        get: -> "hello"

    expect(obj.foo).toEqual "hello"

  describe "default property getter", ->
    it "reads an instance variable", ->
      obj = TwoObject.create
        foo: Property()

      obj._foo = "hello"
      expect(obj.foo).toEqual "hello"

  describe "default property setter", ->
    it "sets an instance variable", ->
      obj = TwoObject.create
        foo: Property()

      obj.foo = "hello"
      expect(obj._foo).toEqual "hello"

    it "is not created when only getter is specified", ->
      obj = TwoObject.create
        foo: Property get: -> "hello"

      expect(-> obj.foo = "bad").toThrow()

    it "throws an error when attempting to write a readonly property", ->
      obj = TwoObject.create
        foo: Property readonly: true

      expect(-> obj.foo = "bad").toThrow()

  describe "when extending from Object", ->
    it "allows properties to be set in the constructor", ->
      Derived = TwoObject.extend
        foo: Property
          get: -> @_fooValue
          set: (value) -> @_fooValue = value

      obj = new Derived(foo: 123)
      expect(obj.foo).toEqual 123
      expect(obj._fooValue).toEqual 123

    it "and using #create, it can have a getter", ->
      Derived = TwoObject.extend
        foo: Property
          get: -> "hello"

      expect(Derived.create().foo).toEqual "hello"

    it "and using #new, it can have a getter", ->
      Derived = TwoObject.extend
        foo: Property
          get: -> "hello"

      expect(new Derived().foo).toEqual "hello"

    it "and using #create, it can have a setter", ->
      Derived = TwoObject.extend
        foo: Property
          set: (value) -> @_value = value

      obj = Derived.create()
      obj.foo = "hello"

      expect(obj._value).toEqual "hello"

    it "and using #new, it can have a setter", ->
      Derived = TwoObject.extend
        foo: Property
          set: (value) -> @_value = value

      obj = new Derived()
      obj.foo = "hello"

      expect(obj._value).toEqual "hello"

    it "can overwrite a property via the constructor", ->
      Derived = TwoObject.extend
        foo: Property
          get: -> "hello"

      object = new Derived
        foo: Property
          get: -> "goodbye"

      expect(object.foo).toEqual "goodbye"

    it "can overwrite a property in a derived class", ->
      Base = TwoObject.extend
        foo: Property
          get: -> "hello"

      Derived = Base.extend
        foo: Property
          get: -> "goodbye"

      expect(new Derived().foo).toEqual "goodbye"

    it "can call a super class property", ->
      Base = TwoObject.extend
        foo: Property
          get: -> "hello"

      Derived = Base.extend
        foo: Property
          get: -> @_super() + " there"

      expect(new Derived().foo).toEqual "hello there"

    it "can call a super class property two levels deep", ->
      Base = TwoObject.extend
        foo: Property
          get: -> "hello"

      Derived = Base.extend
        foo: Property
          get: -> @_super() + " there"

      MoreDerived = Derived.extend
        foo: Property
          get: -> @_super() + " world"

      expect(new MoreDerived().foo).toEqual "hello there world"

