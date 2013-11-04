define (require) ->
  $ = require "jquery"
  require "jquery.mousewheel"
  gl = require "gl-matrix"
  Box = require "two/box"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Dialog = require "./dialog"
  Disc = require "two/disc"
  KeyCodes = require "./key_codes"
  Material = require "two/material"
  MouseButtons = require "./mouse_buttons"
  Projector = require "two/projector"
  Scene = require "two/scene"
  SelectionBox = require "./selection_box"
  Signal = require "signals"

  run: ->
    dialog = new Dialog()
    $("#editor").append dialog.$domElement
    $viewport = $(".viewport")

    dialog.setBody(
      """
        <table>
          <tr>
            <td>Name</td>
              <td><input></input></td>
          </tr>
          <tr>
            <td>Parent</td>
            <td><select><option>Scene</option></select></td>
          </tr>
          <tr>
            <td>Position</td>
            <td>
              <input type="number" value="3"></input>
              <input type="number" value="0.0"></input>
            </td>
          </tr>
          <tr>
            <td>Rotation</td>
            <td>
              <input class="format-degrees" type="number" value="3"></input>
            </td>
          </tr>
          <tr>
            <td>Scale</td>
            <td>
              <input type="number" value="99993" />
              <input type="number" value="0.0" />
            </td>
          </tr>
          <tr>
            <td>Visible</td>
            <td><input type="checkbox"/></td>
          </tr>
          <tr>
            <td>User Data</td>
            <td><textarea></textarea></td>
          </tr>
        </table>
        <table style="display:none">
          <tr>
            <td>Foo</td>
              <td><input></input></td>
          </tr>
          <tr>
            <td>Parent</td>
            <td><select><option>Scene</option></select></td>
          </tr>
          <tr>
            <td>Position</td>
            <td>
              <input type="number" value="3"></input>
              <input type="number" value="0.0"></input>
            </td>
          </tr>
          <tr>
            <td>Rotation</td>
            <td>
              <input class="format-degrees" type="number" value="3"></input>
            </td>
          </tr>
          <tr>
            <td>Scale</td>
            <td>
              <input type="number" value="99993" />
              <input type="number" value="0.0" />
            </td>
          </tr>
          <tr>
            <td>Visible</td>
            <td><input type="checkbox"/></td>
          </tr>
          <tr>
            <td>User Data</td>
            <td><textarea></textarea></td>
          </tr>
        </table>
      """)

    dialog.setFooter(
      """
        <div class="panel tabs">
          <span class="tab active">Tab 1</span>
          <span class="tab">Tab 2</span>
          <span class="tab">Tab 3</span>
        </div>
      """)

    @renderer = new CanvasRenderer(width: $viewport.width(), height: $viewport.height(), autoClear: false)
    @scene = new Scene()
    @sceneGizmos = new Scene()
    @camera = new Camera(width: 15, aspectRatio: @renderer.getWidth() / @renderer.getHeight())
    @projector = new Projector(@camera, @renderer)

    @scene.add new Disc(radius: 3, material: new Material(fillColor: "#BE0028"))

    @canvas = @renderer.domElement
    @$canvas = $(@canvas)
    $viewport.append(@$canvas)

    @maxCameraWidth = 1000
    @minCameraWidth = 1
    @zoomSpeed = 1

    @_selectionBox = new SelectionBox(@on, @projector)
    @_render()

    $(document).on "keydown keyup mousedown mouseup mousemove mousewheel", => @_onUserInput.apply @, arguments
    @on.cursorStyleChanged.add @_onCursorStyleChanged, @
    @on.gizmoChanged.add @_onGizmoChanged, @

    @on.mouseMoved.add @_onMouseMoveDefault, @
    @on.mouseButtonReleased.add @_onMouseUpDefault, @

    @on.mouseButtonPressed.add @_onSelectionStarted, @
    @on.mouseButtonReleased.add @_onSelectionFinished, @

    @on.mouseMoved.add @_onGrabToolMoved, @, 2
    @on.mouseButtonPressed.add @_onGrabStarted, @, 2
    @on.mouseButtonReleased.add @_onGrabStopped, @, 2
    @on.keyPressed.add @_onGrabToolSelected, @
    @on.keyReleased.add @_onGrabToolDeselected, @

  on:
    cursorStyleChanged: new Signal()
    gizmoChanged: new Signal()
    keyPressed: new Signal()
    keyReleased: new Signal()
    mouseButtonPressed: new Signal()
    mouseButtonReleased: new Signal()
    mouseMoved: new Signal()

  _render: ->
    @renderer.clear()
    @renderer.render(@scene, @camera)
    @renderer.render(@sceneGizmos, @camera)

  _onUserInput: (e) ->
    handled = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments
    if handled
      e.preventDefault()
      e.stopPropagation()

  _onKeydown: (e) ->
    @on.keyPressed.dispatch e
    return e.target == @canvas

  _onKeyup: (e) ->
    @on.keyReleased.dispatch e
    return e.target == @canvas

  _onMousedown: (e) ->
    if e.target == @canvas
      gizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @on.mouseButtonPressed.dispatch e, gizmo
    return e.target == @canvas

  _onMouseup: (e) ->
    if e.target == @canvas
      gizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @on.mouseButtonReleased.dispatch e, gizmo
    return e.target == @canvas

  _onMousemove: (e) ->
    if e.target == @canvas
      gizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @on.mouseMoved.dispatch e, gizmo
    e.target == @canvas

  _onSelectionStarted: (e, gizmo) ->
    return unless e.target == @canvas && e.which == MouseButtons.LEFT

    @_mouseDownPoint = gl.vec2.fromValues e.offsetX, e.offsetY

  _onSelectionFinished: (e, gizmo) ->
    mouseDownPoint = @_mouseDownPoint
    @_mouseDownPoint = null

    return unless e.target == @canvas && mouseDownPoint?

    mouseUpPoint = gl.vec2.fromValues e.offsetX, e.offsetY

    if gl.vec2.squaredDistance(mouseUpPoint, mouseDownPoint) <= 1
      @_onPick(mouseDownPoint)

  _onGrabToolSelected: (e) ->
    return unless e.keyCode == KeyCodes.SHIFT

    @_grabTool = true
    @_setCursor "-webkit-grab" unless @_grabbing

  _onGrabToolDeselected: (e) ->
    return unless e.keyCode == KeyCodes.SHIFT

    @_grabTool = false
    @_setCursor "auto" unless @_grabbing

  _onGrabStarted: (e) ->
    return unless @_grabTool && e.which == MouseButtons.LEFT

    @_grabbing = true
    @_grabAnchor = gl.vec2.fromValues(e.pageX, e.pageY)
    @_initialCameraPosition = @camera.getPosition()

    @_setCursor "-webkit-grabbing"
    return false

  _onGrabToolMoved: (e) ->
    unless @_grabbing
      return !@_grabTool

    grabPoint = gl.vec2.fromValues(e.pageX, e.pageY)
    grabAnchor = gl.vec2.clone(@_grabAnchor)
    grabPoint = @projector.unproject grabPoint
    grabAnchor = @projector.unproject grabAnchor

    grabVector = gl.vec2.create()
    gl.vec2.subtract grabVector, grabAnchor, grabPoint

    gl.vec2.add grabVector, @_initialCameraPosition, grabVector
    @camera.setPosition grabVector

    @_render()
    return false

  _onGrabStopped: (e) ->
    return unless e.which == MouseButtons.LEFT && @_grabbing

    @_grabbing = false

    if @_grabTool
      @_setCursor "-webkit-grab"
    else
      @_setCursor "auto"

    return false

  _onMouseMoveDefault: (e) ->
    @_setCursor "auto"

  _onMouseUpDefault: (e, gizmo) ->
    @_setCursor "auto" unless gizmo?

  _onMousewheel: (e, delta, deltaX, deltaY) ->
    return unless e.target == @canvas && deltaY != 0

    return @_onZoom(deltaY*0.006, gl.vec2.fromValues e.offsetX, e.offsetY) || true

  _onZoom: (amount, screenPoint) ->
    width = @camera.getWidth()
    # Zoom speed gets faster the more zoomed out we are
    width -= amount*@zoomSpeed*width*0.6
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    @camera.setWidth(width)

    # Zoom in on mouse cursor
    if @minCameraWidth < width < @maxCameraWidth
      worldPoint = @projector.unproject screenPoint

      t = amount + 0.001
      @camera.setPosition(gl.vec2.lerp worldPoint, @camera.getPosition(), worldPoint, t)

    @_render()

  _onPick: (screenPoint) ->
    return if @projector.pick screenPoint, @sceneGizmos

    selected = @projector.pick screenPoint, @scene
    return if @_selectedObject is selected

    @_selectedObject = selected
    if @_selectedObject?
      @_onPickObject(selected, screenPoint)
    else
      @_onUnpick()

    @_render()

  _onPickObject: (object, screenPoint) ->
    unless @_selectionBox.isAttached()
      @sceneGizmos.add @_selectionBox

    @_selectionBox.attachTo object

    @on.mouseMoved.dispatch(
      {x: screenPoint[0], y: screenPoint[1]},
      @projector.pick screenPoint, @sceneGizmos)

  _onUnpick: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox.detach()

  _onCursorStyleChanged: (newStyle) ->
    @_setCursor newStyle

  _onGizmoChanged: ->
    @_render()

  _setCursor: (cursor) ->
    @$canvas.css "cursor", cursor

