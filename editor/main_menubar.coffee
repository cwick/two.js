define ["jquery", "./lib/menubar"], ($, Menubar) ->
  class MainMenubar extends Menubar
    constructor: (@_signals) ->
      super

      @addItem "File"
      @addItem "Edit"
      @addItem "View"
