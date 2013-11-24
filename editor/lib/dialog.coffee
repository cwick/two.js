define ["jquery", "../mouse_buttons", "./draggable", "./resizable", "./control"], \
       ($, MouseButtons, Draggable, Resizable, Control) ->
  class Dialog extends Control
    constructor: ->
      super $("<div/>", class: "panel dialog draggable resizable")

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

    getBody: ->
      @$domElement.find(".dialog-body")

    setFooter: (value) ->
      @$domElement.find(".dialog-footer").html(value)

