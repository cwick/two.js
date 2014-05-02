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

  describe "when extending from Object", ->
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

