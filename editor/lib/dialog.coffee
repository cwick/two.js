define ["jquery", "../mouse_buttons", "./draggable", "./resizable", "./control"], \
       ($, MouseButtons, Draggable, Resizable, Control) ->
  class Dialog extends Control
    constructor: (options={}) ->
      super $("<div/>", class: "panel-vertical dialog")

      options.draggable ?= true
      options.resizable ?= true

      if options.resizable
        @$domElement.addClass "resizable"

        @_appendElement(e) for e in [
          "bottom-resize"
          "top-resize",
          "right-resize",
          "left-resize",
          "bottom-left-resize",
          "bottom-right-resize",
          "top-left-resize",
          "top-right-resize"]

      header = @_appendElement "dialog-header"

      if options.draggable
        header.addClass "drag-handle"
        @$domElement.addClass "draggable"


      @_appendElement(e) for e in [
        "toolbar panel hidden",
        "dialog-body panel no-footer",
        "dialog-footer"]

      Draggable.enhance @domElement if options.draggable
      Resizable.enhance @domElement if options.resizable

      @setTitle options.title

    setBody: (value) ->
      @$domElement.find(".dialog-body").html(value)

    getBody: ->
      @$domElement.find(".dialog-body").children().first()

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

    openModal: ->
      parent = $("body")
      overlay = $("<div/>", class: "modal-overlay", tabindex: 0)
      parent.append overlay

      @open parent
      @setTranslation $(document).width()/2 - @getWidth()/2, $(document).height()/2 - @getHeight()/2
      overlay.focus()

    close: ->
      @$domElement.remove()
      $(".modal-overlay").remove()

    _appendElement: (klass) ->
      el = $("<div/>", class: klass)
      @$domElement.append el
      el
