`import Canvas from "canvas"`
`import DeviceMetrics from "device_metrics"`

describe "Canvas", ->
  it "has a default size", ->
    canvas = new Canvas()
    expect(canvas.width).toEqual 640
    expect(canvas.height).toEqual 480

  it "has width and height", ->
    canvas = new Canvas(width: 10, height: 20)
    expect(canvas.width).toEqual 10
    expect(canvas.height).toEqual 20

  it "sizes the canvas according to devicePixelRatio", ->
    DeviceMetrics.override devicePixelRatio: 10

    canvas = new Canvas(width: 10, height: 20)
    expect(canvas.domElement.width).toEqual 100
    expect(canvas.domElement.height).toEqual 200
    expect(canvas.domElement.style.width).toEqual "10px"
    expect(canvas.domElement.style.height).toEqual "20px"

