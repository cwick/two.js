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

    $("input").change (e) => @_onGridChanged(isVisible: $(e.target).is(':checked'))
    @on.cursorStyleChanged.add @_onCursorStyleChanged, @
    @on.gizmoChanged.add @_onGizmoChanged, @

    @on.gridChanged.add @_onGridChanged, @
    @on.zoomLevelChanged.add @_onZoomLevelChanged, @
    @on.grabToolSelected.add @_onGrabToolSelected, @
    @on.grabToolDeselected.add @_onGrabToolDeselected, @

    @on.stylusTouched.add @_onStylusTouched, @
    @on.stylusDragged.add @_onStylusDragged, @
    @on.stylusReleased.add @_onStylusReleased, @
    @on.objectSelected.add @_onObjectSelected, @
    @on.objectDeselected.add @_onObjectDeselected, @

    @on.grabToolStarted.add @_onGrabToolStarted, @
    @on.grabToolStopped.add @_onGrabToolStopped, @
    @on.grabToolDragged.add @_onGrabToolDragged, @

  on:
    cursorStyleChanged: new Signal()
    gizmoChanged: new Signal()
    grabToolDeselected: new Signal()
    grabToolSelected: new Signal()
    grabToolStarted: new Signal()
    grabToolStopped: new Signal()
    grabToolDragged: new Signal()
    gridChanged: new Signal()
    objectDeselected: new Signal()
    objectSelected: new Signal()
    stylusDragged: new Signal()
    stylusMoved: new Signal()
    stylusReleased: new Signal()
    stylusTouched: new Signal()
    zoomLevelChanged: new Signal()

  _render: ->
    @renderer.clear()
    @renderer.render(@sceneGrid, @camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@sceneGizmos, @camera)

  _onZoomLevelChanged: (amount) ->
    width = @camera.getWidth()
    # Zoom speed gets faster the more zoomed out we are
    width -= amount*@zoomSpeed*width*0.6
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    @camera.setWidth(width)

    @_render()

  _onCursorStyleChanged: (newStyle) ->
    @_setCursor newStyle

  _onGizmoChanged: ->
    @_render()

  _onStylusTouched: ->
    if @_grabTool
      @on.grabToolStarted.dispatch()

  _onStylusDragged: (e) ->
    if @_grabbing
      @on.grabToolDragged.dispatch(e)

  _onStylusReleased: (e) ->
    if @_grabbing
      @on.grabToolStopped.dispatch()
      return

    selectionThreshold = 2
    return unless e.isOnCanvas
    return if Math.abs(e.delta[0]) > selectionThreshold || Math.abs(e.delta[1]) > selectionThreshold

    object = @projector.pick e.canvasStartPoint, @scene
    if object?
      @on.objectSelected.dispatch(object)
    else
      @on.objectDeselected.dispatch()

  _onObjectSelected: (object) ->
    unless @_selectionBox.isAttached()
      @sceneGizmos.add @_selectionBox

    @_selectionBox.attachTo object
    @_render()

  _onObjectDeselected: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox.detach()
    @_render()

  _onGrabToolStarted: ->
    @_grabbing = true
    @_initialCameraPosition = @camera.getPosition()

    @_setCursor "-webkit-grabbing"

  _onGrabToolStopped: (e) ->
    @_grabbing = false

    if @_grabTool
      @_setCursor "-webkit-grab"
    else
      @_setCursor "auto"

  _onGrabToolSelected: ->
    @_grabTool = true
    @_setCursor "-webkit-grab" unless @_grabbing

  _onGrabToolDeselected: ->
    @_grabTool = false
    @_setCursor "auto" unless @_grabbing

  _onGrabToolDragged: (e) ->
    worldStartPoint = @projector.unproject(e.canvasStartPoint)
    worldEndPoint = @projector.unproject(e.canvasEndPoint)
    worldTranslation = gl.vec2.create()
    newCameraPosition = gl.vec2.create()

    gl.vec2.subtract worldTranslation, worldStartPoint, worldEndPoint
    gl.vec2.add newCameraPosition, @_initialCameraPosition, worldTranslation

    @camera.setPosition newCameraPosition

    @_render()

  _setCursor: (cursor) ->
    @$canvas.css "cursor", cursor

  _onGridChanged: (options) ->
    o.setVisible(options.isVisible) for o in @sceneGrid.getChildren()
    @_render()

