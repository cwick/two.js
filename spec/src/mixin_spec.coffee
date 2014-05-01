`import Mixin from "mixin";`

describe "Mixin", ->
  it "can be created", ->
    Mixin.create()

  it "can mix its properties into a base object", ->
    base = new Object()
    mixin = Mixin.create foo: "bar"

    mixin.extend base
    expect(base.foo).toEqual "bar"

