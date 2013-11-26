define ["jquery", "../mouse_buttons", "./draggable", "./resizable", "./control"], \
       ($, MouseButtons, Draggable, Resizable, Control) ->
  class Dialog extends Control
    constructor: (options={}) ->
      super $("<div/>", class: "panel-vertical dialog draggable resizable")

      for c in ["bottom-resize"
                "top-resize",
                "right-resize",
                "left-resize",
                "bottom-left-resize",
                "bottom-right-resize",
                "top-left-resize",
                "top-right-resize",
                "dialog-header drag-handle",
                "toolbar panel hidden",
                "dialog-body panel no-footer",
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

    setToolbar: (value) ->
      toolbar = @$domElement.find(".toolbar")
      toolbar.html(value)

      if value
        toolbar.removeClass "hidden"
      else
        toolbar.addClass "hidden"

    setHeader: (value) ->
      @$domElement.find(".dialog-header").html(value)

    setFooter: (value) ->
      @$domElement.find(".dialog-footer").html(value)

      if value
        @$domElement.find(".dialog-body").removeClass "no-footer"
      else
        @$domElement.find(".dialog-body").addClass "no-footer"

