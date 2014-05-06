`import "./spec_helper"`
`import Matrix2d from "matrix2d"`
`module gl from "lib/gl-matrix"`

describe "Matrix2d", ->
  it "has the identity matrix by default", ->
    m = new Matrix2d()
    expect(m.values).toEqual new Float32Array([1,0,0,1,0,0])

  it "can translate", ->
    m = new Matrix2d().translate(5, 6)
    expect(m.values).toEqual new Float32Array([1,0,0,1,5,6])

  it "can rotate", ->
    m = new Matrix2d().rotate(Math.PI)
    expect(m.values).toEqual new Float32Array([-1,0,0,-1,0,0])

  it "can multiply", ->
    m1 = new Matrix2d()
    m2 = new Matrix2d()
    expect(m1.multiply(m2).values).toEqual new Float32Array([1,0,0,1,0,0])

  it "can scale", ->
    m = new Matrix2d()
    expect(m.scale(2,3).values).toEqual new Float32Array([2,0,0,3,0,0])

  it "can be scaled equally along both dimensions by omitting the second argument", ->
    m1 = new Matrix2d()
    m2 = new Matrix2d()

    expect(m1.scale(6,6).values).toEqual m2.scale(6).values

  it "can be initialized from values", ->
    m = new Matrix2d([1,2,3,4,5,6])
    expect(m.values).toEqual [1,2,3,4,5,6]

  it "can be reset to identity", ->
    m = new Matrix2d([1,2,3,4,5,6])
    m.reset()
    expect(m.values).toEqual [1,0,0,1,0,0]

  it "can be cloned", ->
    values = [1,2,3,4,5,6]
    m = new Matrix2d(values)
    clone = m.clone()

    expect(clone.values).toEqual m.values
    values[0] = null
    expect(clone.values[0]).not.toBeNull()

  it "the identity matrix can be cloned", ->
    m = new Matrix2d()
    expect(m.clone().values).toEqual m.values

