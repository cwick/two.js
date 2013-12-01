define (require) ->
  uuid = require "uuid"
  Color = require "./color"
  Utils = require "./utils"

  class Material
    constructor: (options) ->
      @isFixedSize = options.isFixedSize ?= false
      @opacity = options.opacity ?= 1
      @_id = options.id ?= uuid.v4()

    cloneProperties: (overrides) ->
      Utils.merge
        isFixedSize: @isFixedSize
        opacity: @opacity, overrides

    getId: -> @_id

    _makeColor: (color, _default) ->
      _default = "black" if _default is undefined
      color ?= _default

      if typeof color == "string"
        new Color(color)
      else if color instanceof Color
        color
      else
        throw new Error("Invalid color value #{color}. Must be a string or Color instance")
