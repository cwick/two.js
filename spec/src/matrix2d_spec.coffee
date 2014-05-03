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
