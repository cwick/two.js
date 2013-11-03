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
  Scene = require "two/scene"
  SelectionBox = require "./selection_box"

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
    @camera = new Camera(width: 15, screenWidth: @renderer.getWidth(), screenHeight: @renderer.getHeight())

    @scene.add new Disc(radius: 3, material: new Material(fillColor: "#BE0028"))

    @canvas = @renderer.domElement
    @$canvas = $(@canvas)
    $viewport.append(@$canvas)

    @maxCameraWidth = 1000
    @minCameraWidth = 1
    @zoomSpeed = 1

    @_render()

    $(document).on "keydown keyup mousedown mouseup mousemove mousewheel", => @_onUserInput.apply @, arguments

  _render: ->
    @renderer.clear()
    @renderer.render(@scene, @camera)
    @renderer.render(@sceneGizmos, @camera)

  _setCursor: (cursor) ->
    @$canvas.css "cursor", cursor

  _updateCursorStyle: (x,y) ->
    if @camera.pick(gl.vec2.fromValues(x,y), @sceneGizmos)
      @_setCursor "move"
    else
      @_setCursor "auto"

  _onUserInput: (e) ->
    handled = @["_on#{e.type.charAt(0).toUpperCase() + e.type.slice(1)}"].apply @, arguments
    if handled
      e.preventDefault()
      e.stopPropagation()

  _onKeydown: (e) ->
    if e.keyCode == KeyCodes.SHIFT
      return @_onGrabToolSelected e && true

  _onKeyup: (e) ->
    if e.keyCode == KeyCodes.SHIFT
      return @_onStopGrab(e) || true

  _onMousedown: (e) ->
    return unless e.which == MouseButtons.LEFT

    if e.target == @canvas
      @_mouseDownPoint = gl.vec2.fromValues e.offsetX, e.offsetY

    if @_grabTool
      return @_onBeginGrabbing(e) || true

  _onMouseup: (e) ->
    return unless e.which == MouseButtons.LEFT

    if e.target == @canvas
      mouseUpPoint = gl.vec2.fromValues e.offsetX, e.offsetY

    mouseDownPoint = @_mouseDownPoint
    @_mouseDownPoint == null

    if @_grabbing
      return @_onStopGrabbing(e) || true
    else if e.target == @canvas && gl.vec2.squaredDistance(mouseUpPoint, mouseDownPoint) <= 1
      return @_onPick(mouseDownPoint) || true

  _onMousemove: (e) ->
    if @_grabbing
      return @_onGrabbing(e) || true

    return unless e.target == @canvas && !@_grabTool

    @_updateCursorStyle(e.offsetX, e.offsetY)

  _onMousewheel: (e, delta, deltaX, deltaY) ->
    return unless e.target == @canvas && deltaY != 0

    return @_onZoom(deltaY*0.006, gl.vec2.fromValues e.offsetX, e.offsetY) || true

  _onGrabToolSelected: ->
    @_grabTool = true
    @_setCursor "-webkit-grab"

  _onStopGrab: ->
    @_grabTool = false
    @_setCursor "auto" unless @_grabbing

  _onBeginGrabbing: (e) ->
    @_grabbing = true
    @_grabAnchor = gl.vec2.fromValues(e.pageX, e.pageY)
    @_initialCameraPosition = @camera.getPosition()

    @_setCursor "-webkit-grabbing"

  _onGrabbing: (e) ->
    grabPoint = gl.vec2.fromValues(e.pageX, e.pageY)
    grabAnchor = gl.vec2.clone(@_grabAnchor)
    @camera.unproject grabPoint, grabPoint
    @camera.unproject grabAnchor, grabAnchor

    grabVector = gl.vec2.create()
    gl.vec2.subtract grabVector, grabAnchor, grabPoint

    gl.vec2.add grabVector, @_initialCameraPosition, grabVector
    @camera.setPosition grabVector

    @_render()

  _onStopGrabbing: ->
    @_grabbing = false

    if @_grabTool
      @_setCursor "-webkit-grab"
    else
      @_setCursor "auto"

  _onZoom: (amount, screenPoint) ->
    width = @camera.getWidth()
    # Zoom speed gets faster the more zoomed out we are
    width -= amount*@zoomSpeed*width
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    worldPoint = gl.vec2.create()
    @camera.unproject worldPoint, screenPoint
    @camera.setWidth(width)

    # Zoom in on mouse cursor
    if @minCameraWidth < width < @maxCameraWidth
      t = Math.abs(amount) + 0.001
      @camera.setPosition(gl.vec2.lerp worldPoint, @camera.getPosition(), worldPoint, t)

    @_updateCursorStyle(screenPoint[0], screenPoint[1])
    @_render()

  _onPick: (screenPoint) ->
    return if @camera.pick screenPoint, @sceneGizmos

    selected = @camera.pick screenPoint, @scene
    return if @_selectedObject is selected

    @_selectedObject = selected
    if @_selectedObject?
      @_onPickObject(selected)
    else
      @_onUnpick()

    @_updateCursorStyle(screenPoint[0], screenPoint[1])
    @_render()

  _onPickObject: (object) ->
    unless @_selectionBox?
      @_selectionBox = new SelectionBox()
      @sceneGizmos.add @_selectionBox

    @_selectionBox.attachTo object

  _onUnpick: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox = null

