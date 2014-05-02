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

