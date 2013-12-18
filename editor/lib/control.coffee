define ["jquery", "../utils"], ($, Utils) ->
  class Control
    constructor: (@$domElement = $("<div/>"), options={}) ->
      @domElement = @$domElement.get(0)

      if options.id?
        @$domElement.attr "id", options.id

    toString: ->
      new XMLSerializer().\
          serializeToString(@$domElement.get(0)).\
          replace(///\s+xmlns="http://www.w3.org/1999/xhtml"///g, "")

    hide: ->
      @$domElement.hide()

    show: ->
      @$domElement.show()

    blur: ->
      @$domElement.blur()

    setWidth: (value) ->
      @$domElement.width value

    setHeight: (value) ->
      @$domElement.height value

    getWidth: ->
      @$domElement.width()

    getHeight: ->
      @$domElement.height()

    setTranslation: (x,y) ->
      Utils.setTranslation @$domElement, x, y

    addClass: (c) ->
      @$domElement.addClass c
