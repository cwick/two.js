define (require) ->
  Color = require "color"

  describe "Color", ->
    beforeEach ->
      @color = new Color()

    it "should be white by default", ->
      expect(@color.r).toEqual 255
      expect(@color.g).toEqual 255
      expect(@color.b).toEqual 255
      expect(@color.a).toEqual 1

    it "should return the CSS color", ->
      @color.r = 48
      @color.g = 59
      @color.b = 11
      @color.a = 0.2
      expect(@color.css()).toEqual "rgba(#{@color.r}, #{@color.g}, #{@color.b}, #{@color.a})"

    it "should parse css color words", ->
      @color = new Color("blue")
      expect(@color.css()).toEqual "blue"
      expect(@color.r).toEqual 0
      expect(@color.g).toEqual 0
      expect(@color.b).toEqual 255

    it "should parse css rgb", ->
      @color = new Color("rgb(1,2,3)")
      expect(@color.css()).toEqual "rgb(1,2,3)"
      expect(@color.r).toEqual 1
      expect(@color.g).toEqual 2
      expect(@color.b).toEqual 3

    it "should parse css rgba", ->
      @color = new Color("rgba(1,2,3, 0.3)")
      expect(@color.css()).toEqual "rgba(1,2,3, 0.3)"
      expect(@color.r).toEqual 1
      expect(@color.g).toEqual 2
      expect(@color.b).toEqual 3
      expect(@color.a).toEqual 0.3

    it "can clone itself", ->
      @color = new Color(r: 1, g: 2, b: 3, a: 4)
      color2 = @color.clone(a: 10)
      expect(color2.r).toEqual @color.r
      expect(color2.g).toEqual @color.g
      expect(color2.b).toEqual @color.b
      expect(color2.a).toEqual 10
