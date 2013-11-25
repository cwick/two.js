define ["jquery", "../mouse_buttons", "./draggable", "./resizable", "./control"], \
       ($, MouseButtons, Draggable, Resizable, Control) ->
  class Dialog extends Control
    constructor: (options) ->
      super $("<div/>", class: "panel dialog draggable resizable")

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

      @setTitle options.title

    setBody: (value) ->
      @$domElement.find(".dialog-body").html(value)

    getBody: ->
      @$domElement.find(".dialog-body")

    setTitle: (title) ->
      @setHeader "<h1 class='title'>#{title}</h1>"

    setHeader: (value) ->
      @$domElement.find(".dialog-header").html(value)

    setFooter: (value) ->
      @$domElement.find(".dialog-footer").html(value)

