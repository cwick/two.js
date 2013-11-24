define ["jquery", "../mouse_buttons", "./draggable", "./resizable"], ($, MouseButtons, Draggable, Resizable) ->
  class Dialog
    constructor: ->
      @$domElement = $("<div/>", class: "panel dialog draggable resizable")
      @domElement = @$domElement.get(0)

      @$domElement.width "200px"

      for c in ["bottom-resize"
                "top-resize",
                "right-resize",
                "left-resize",
                "bottom-left-resize",
                "bottom-right-resize",
                "top-left-resize",
                "top-right-resize",
                "dialog-header drag-handle",
                "dialog-body",
                "dialog-footer"]
        @$domElement.append $("<div/>", class: c)

      Draggable.enhance @domElement
      Resizable.enhance @domElement

    setBody: (value) ->
      @$domElement.find(".dialog-body").html(value)

    setFooter: (value) ->
      @$domElement.find(".dialog-footer").html(value)

    hide: ->
      @$domElement.hide()

    show: ->
      @$domElement.show()
