`import TwoObject from "object"`
`import Property from "property"`

describe "TwoObject", ->
  it "can be instantiated with 'new'", ->
    obj = new TwoObject(a: 1)
    expect(obj.a).toEqual 1

  describe "#create", ->
    it "can be created with properties", ->
      obj = TwoObject.create
        a: 1
        b: "two"
        c: -> "three"

      expect(obj.a).toEqual 1
      expect(obj.b).toEqual "two"
      expect(obj.c()).toEqual "three"

    it "properties are not shared between instances", ->
      props = a: 1, b: 2
      obj1 = TwoObject.create props
      obj2 = TwoObject.create props

      obj1.a = "not shared"

      expect(obj2.a).toEqual 1

    it "throws an error if it was not called with an options object", ->
      expect(-> TwoObject.create(124)).toThrow(new TypeError("Two.Object must be initialized with an options object."))

  describe "creating a subclass", ->
    it "can extend a class", ->
      TestClass = TwoObject.extend
        a: 1
        b: -> 2

      obj = TestClass.create()
      expect(obj.a).toEqual 1
      expect(obj.b()).toEqual 2

    it "can have an initializer", ->
      hasInitialized = false

      TestClass = TwoObject.extend
        initialize: -> hasInitialized = true

      TestClass.create()
      expect(hasInitialized).toBe true

      hasInitialized = false

      new TestClass()
      expect(hasInitialized).toBe true

    it "can pass arguments to the initializer", ->
      TestClass = TwoObject.extend
        initialize: (options) ->
          @options = options

      expect(new TestClass(a: 1, b: 2).options).toEqual a: 1, b: 2

    it "the default initializer calls the parent initializer", ->
      Base = TwoObject.extend
        initialize: ->
          @baseWasCalled = true

      NoInitializer = Base.extend()

      MoreDerived = NoInitializer.extend
        initialize: ->
          @moreDerivedWasCalled = true

      moreDerived = new MoreDerived()
      expect(moreDerived.moreDerivedWasCalled).toBe true
      expect(moreDerived.baseWasCalled).toBe true

    it "shares object property values between instances", ->
      proto = notShared: 1, shared: [1,2,3]
      Class1 = TwoObject.extend proto
      Class2 = TwoObject.extend proto

      obj1 = Class1.create()
      obj2 = Class2.create()

      obj1.notShared = 3
      obj1.shared.push("shared")
      expect(obj2.notShared).toEqual 1
      expect(obj2.shared[3]).toEqual "shared"

    it "can extend a class two levels deep", ->
      Base = TwoObject.extend
        a: 1

      Derived = Base.extend
        b: 2

      derived = Derived.create()
      expect(derived.a).toEqual 1
      expect(derived.b).toEqual 2

    it "derived class properties override base class properties", ->
      Base = TwoObject.extend
        a: 1

      Derived = Base.extend
        a: 2

      derived = Derived.create()
      expect(derived.a).toEqual 2

    it "properties passed in the constructor override base properties", ->
      Base = TwoObject.extend
        a: 1
      base = Base.create a: 2
      expect(base.a).toEqual 2

    it "derived classes can be instantiated with 'new'", ->
      Derived = TwoObject.extend
        a: 3

      derived = new Derived(b: 4)
      expect(derived.a).toEqual 3
      expect(derived.b).toEqual 4

    it "adds methods to the object's prototype", ->
      hello = -> "world"

      Derived = TwoObject.extend
        hello: hello

      expect(Derived.prototype.hello).toBe hello







