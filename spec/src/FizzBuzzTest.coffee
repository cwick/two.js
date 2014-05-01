`import Object2d from "object2d";`

describe "FizzBuzz integration test", ->
  fb = null
  out = null

  doFizzBuzz = (n, s) ->
    bos = window.console =
      _buffer: ""
      info: (output) -> @_buffer += output
      log: -> @info.apply @, arguments

    fb.fizzbuzz(n)

    expect(s).toEqual bos._buffer

  beforeEach ->
    fb = new FizzBuzz()
    out = window.console

  afterEach ->
    window.console = out

  it "Counts using the FizzBuzz algorithm", ->
    doFizzBuzz(1, "1\n")
    doFizzBuzz(2, "1\n2\n")
    doFizzBuzz(3, "1\n2\nFizz\n")
    doFizzBuzz(4, "1\n2\nFizz\n4\n")
    doFizzBuzz(5, "1\n2\nFizz\n4\nBuzz\n")
    doFizzBuzz(6, "1\n2\nFizz\n4\nBuzz\nFizz\n")
    doFizzBuzz(7, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n")
    doFizzBuzz(8, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\n")
    doFizzBuzz(9, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\n")
    doFizzBuzz(10, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n")
    doFizzBuzz(11, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\n")
    doFizzBuzz(12, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n")
    doFizzBuzz(13, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n")
    doFizzBuzz(14, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\n")
    doFizzBuzz(15, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n")
    doFizzBuzz(16, "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n")

