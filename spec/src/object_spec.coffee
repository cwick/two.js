`import TwoObject from "object"`
`import Mixin from "mixin"`
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

    it "calling super preserves 'this'", ->
      Base = TwoObject.extend
        value: 3
        getValue: -> @value

      Derived = TwoObject.extend
        value: 4
        getValue: -> @_super(Base, "getValue")()

      expect(new Derived().getValue()).toEqual 4

    it "super methods can be accessed by subclasses multiple levels deep", ->
      Base = TwoObject.extend
        a: (x) -> x + " Base"

      Derived = Base.extend
        a: (x) -> @_super(Base, "a")(x) + " Derived"

      MoreDerived = Derived.extend
        a: (x) -> @_super(Derived, "a")(x) + " MoreDerived"

      moreDerived = new MoreDerived()
      expect(moreDerived.a("Hello")).toEqual "Hello Base Derived MoreDerived"

    it "throws TypeError when calling a super method that doesn't exist", ->
      Base = TwoObject.extend
        a: -> @_super(TwoObject, "a")

      expect(-> new Base().a()).toThrow(new TypeError("Superclass property 'a' does not exist."))

  describe "creating a subclass with mixins", ->
    it "can apply a mixin to the subclass", ->
      SimpleMixin = Mixin.create getMixinValue: -> "mixin"

      Derived = TwoObject.extend SimpleMixin,
        getDerivedValue: -> "derived"

      d = Derived.create()
      expect(d.getMixinValue()).toEqual "mixin"
      expect(d.getDerivedValue()).toEqual "derived"

    it "can apply multiple mixins to the subclass", ->
      Mixin1 = Mixin.create mixin1: 1
      Mixin2 = Mixin.create mixin2: 1

      Derived = TwoObject.extend Mixin1, Mixin2,
        derived: 3

      d = Derived.create()
      expect(d.mixin1).toEqual 1
      expect(d.mixin2).toEqual 1
      expect(d.derived).toEqual 3
      expect(Mixin1.detect(d)).toBe true
      expect(Mixin2.detect(d)).toBe true

    it "can extend and create", ->
      FooMixin = Mixin.create foo: -> "bar"
      obj = TwoObject.createWithMixins FooMixin
      expect(obj.foo()).toEqual "bar"

    it "handles mixins from multiple subclasses", ->
      A_Mixin = Mixin.create
        a: -> "a"

      B_Mixin = Mixin.create
        b: -> "b"

      A = TwoObject.extend A_Mixin
      B = A.extend B_Mixin

      base = new B()

      expect(base.a()).toEqual "a"
      expect(base.b()).toEqual "b"

    it "the mixin initializer sets properties on the base object", ->
      TestMixin = Mixin.create
        initialize: ->
          @foo = "hello"

      base = TwoObject.createWithMixins(TestMixin)

      expect(base.foo).toEqual "hello"

    it "the mixin initializer is called after properties are defined", ->
      TestMixin = Mixin.create
        initialize: -> @readonly = 123
        readonly: Property readonly: true

      # Should throw "can't set readonly property"
      expect(-> TwoObject.createWithMixins(TestMixin)).toThrow()






