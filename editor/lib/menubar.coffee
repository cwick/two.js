define ["jquery", "./toolbar"], ($, Toolbar) ->
  class Menubar extends Toolbar
    constructor: (options) ->
      super

      @$domElement.addClass "menubar"

