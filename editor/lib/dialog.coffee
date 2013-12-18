define ["jquery", "../mouse_buttons", "./draggable", "./resizable", "./control"], \
       ($, MouseButtons, Draggable, Resizable, Control) ->
  class Dialog extends Control
    constructor: (options={}) ->
      super $("<div/>", class: "panel-vertical dialog resizable")

      options.draggable ?= true

      header = @_appendElement "dialog-header"
      if options.draggable
        header.addClass "drag-handle"
        @$domElement.addClass "draggable"

      for c in ["bottom-resize"
                "top-resize",
                "right-resize",
                "left-resize",
                "bottom-left-resize",
                "bottom-right-resize",
                "top-left-resize",
                "top-right-resize",
                "toolbar panel hidden",
                "dialog-body panel no-footer",
                "dialog-footer"]
        @_appendElement c


      Draggable.enhance @domElement if options.draggable
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

    open: (parent) ->
      parent.append @$domElement

    openModal: (parent) ->
      @open parent
      @setTranslation parent.width()/2 - @getWidth()/2, parent.height()/2 - @getHeight()/2

    _appendElement: (klass) ->
      el = $("<div/>", class: klass)
      @$domElement.append el
      el
