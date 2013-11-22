define (require) ->
  $ = require "jquery"
  gl = require "gl-matrix"
  Box = require "two/box"
  Camera = require "two/camera"
  CanvasRenderer = require "two/canvas_renderer"
  Dialog = require "./dialog"
  Disc = require "two/disc"
  EditorInput = require "./editor_input"
  Grid = require "./grid"
  KeyCodes = require "./key_codes"
  ShapeMaterial = require "two/shape_material"
  MouseButtons = require "./mouse_buttons"
  Projector = require "two/projector"
  Scene = require "two/scene"
  SelectionBox = require "./selection_box"
  Signal = require "signals"
  Utils = require "two/utils"

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
    @sceneGrid = new Scene()
    @camera = new Camera(width: 15, aspectRatio: @renderer.getWidth() / @renderer.getHeight())
    @projector = new Projector(@camera, @renderer)

    @scene.add new Disc(radius: 3, scale: 0.7, material: new ShapeMaterial(fillColor: "#BE0028"))
    @scene.add new Disc(x:5, y:-3, radius: 2, material: new ShapeMaterial(fillColor: "green"))
    @scene.add new Box(x:-5, y:-1, width: 4, height: 6, material: new ShapeMaterial(fillColor: "yellow", strokeColor: "red"))

    @sceneGrid.add new Grid()

    @canvas = @renderer.domElement
    @$canvas = $(@canvas)
    $viewport.append(@$canvas)

    @maxCameraWidth = 1000
    @minCameraWidth = 1
    @zoomSpeed = 1

    @_selectionBox = new SelectionBox(@on, @projector)
    @_render()

    new EditorInput(@on, @canvas)

    $(document).on "mousedown mouseup mousemove", => @_onUserInput.apply @, arguments
    $("input").change (e) => @_onGridChanged(isVisible: $(e.target).is(':checked'))
    @on.cursorStyleChanged.add @_onCursorStyleChanged, @
    @on.gizmoChanged.add @_onGizmoChanged, @

    @on.mouseMoved.add @_onMouseMoveDefault, @
    @on.mouseButtonReleased.add @_onMouseUpDefault, @

    @on.mouseButtonPressed.add @_onSelectionStarted, @
    @on.mouseButtonReleased.add @_onSelectionFinished, @

    @on.mouseMoved.add @_onGrabToolMoved, @, 2
    @on.mouseButtonPressed.add @_onGrabStarted, @, 2
    @on.mouseButtonReleased.add @_onGrabStopped, @, 2

    @on.gridChanged.add @_onGridChanged, @
    @on.zoomLevelChanged.add @_onZoomLevelChanged, @
    @on.grabToolSelected.add @_onGrabToolSelected, @
    @on.grabToolDeselected.add @_onGrabToolDeselected, @

  on:
    cursorStyleChanged: new Signal()
    gizmoChanged: new Signal()
    gridChanged: new Signal()
    keyPressed: new Signal()
    keyReleased: new Signal()
    mouseButtonPressed: new Signal()
    mouseButtonReleased: new Signal()
    mouseMoved: new Signal()
    grabToolDeselected: new Signal()
    grabToolSelected: new Signal()
    zoomLevelChanged: new Signal()

  _render: ->
    @renderer.clear()
    @renderer.render(@sceneGrid, @camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@sceneGizmos, @camera)

  _onUserInput: (e) ->
    handled = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments
    if handled
      e.preventDefault()
      e.stopPropagation()

  _onMousedown: (e) ->
    if e.target == @canvas
      @_activeGizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @on.mouseButtonPressed.dispatch @_createInputEvent(e, @_activeGizmo, @_activeGizmo)
    return e.target == @canvas

  _onMouseup: (e) ->
    if e.target == @canvas
      gizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @_activeGizmo = null
    @on.mouseButtonReleased.dispatch @_createInputEvent(e, gizmo, @_activeGizmo)
    return e.target == @canvas

  _onMousemove: (e) ->
    if e.target == @canvas
      gizmo = @projector.pick(gl.vec2.fromValues(e.offsetX, e.offsetY), @sceneGizmos)

    @on.mouseMoved.dispatch @_createInputEvent(e, gizmo, @_activeGizmo)
    e.target == @canvas

  _onSelectionStarted: (e) ->
    return unless e.target == @canvas && e.which == MouseButtons.LEFT

    @_mouseDownPoint = gl.vec2.fromValues e.offsetX, e.offsetY

  _onSelectionFinished: (e) ->
    mouseDownPoint = @_mouseDownPoint
    @_mouseDownPoint = null

    return unless e.target == @canvas && mouseDownPoint?

    mouseUpPoint = gl.vec2.fromValues e.offsetX, e.offsetY

    if gl.vec2.squaredDistance(mouseUpPoint, mouseDownPoint) <= 1
      @_onPick(mouseDownPoint)

  _onGrabToolSelected: ->
    @_grabTool = true
    @_setCursor "-webkit-grab" unless @_grabbing

  _onGrabToolDeselected: ->
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

  _onMouseMoveDefault: ->
    @_setCursor "auto"

  _onMouseUpDefault: (e) ->
    @_setCursor "auto" unless e.gizmo?

  _onZoomLevelChanged: (amount) ->
    width = @camera.getWidth()
    # Zoom speed gets faster the more zoomed out we are
    width -= amount*@zoomSpeed*width*0.6
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    @camera.setWidth(width)

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

    event =
      offsetX: screenPoint[0]
      offsetY: screenPoint[1]
      target: @canvas

    gizmo = @projector.pick(screenPoint, @sceneGizmos)

    @on.mouseMoved.dispatch @_createInputEvent(event, gizmo, null)

  _onUnpick: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox.detach()

  _onCursorStyleChanged: (newStyle) ->
    @_setCursor newStyle

  _onGizmoChanged: ->
    @_render()

  _setCursor: (cursor) ->
    @$canvas.css "cursor", cursor

  _createInputEvent: (e, gizmo, activeGizmo) ->
    event = Utils.merge {}, e
    Utils.merge event, gizmo: gizmo, activeGizmo: activeGizmo

  _onGridChanged: (options) ->
    o.setVisible(options.isVisible) for o in @sceneGrid.getChildren()
    @_render()

