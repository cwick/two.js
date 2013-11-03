define (require) ->
  $ = require "jquery"
  require "jquery.mousewheel"
  gl = require "gl-matrix"
  Box = require "./box"
  Camera = require "./camera"
  CanvasRenderer = require "./canvas_renderer"
  Dialog = require "./dialog"
  Disc = require "./disc"
  KeyCodes = require "./key_codes"
  Material = require "./material"
  MouseButtons = require "./mouse_buttons"
  Scene = require "./scene"

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
    @camera = new Camera(screenWidth: @renderer.getWidth(), screenHeight: @renderer.getHeight())

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
    return unless e.which == MouseButtons.LEFT

    if @_grabbing
      return @_onGrabbing(e) || true

  _onMousewheel: (e, delta, deltaX, deltaY) ->
    return unless e.target == @canvas && deltaY != 0

    return @_onZoom(deltaY*0.006, gl.vec2.fromValues e.offsetX, e.offsetY) || true

  _onGrabToolSelected: ->
    @_grabTool = true
    @$canvas.css "cursor", "-webkit-grab"

  _onStopGrab: ->
    @_grabTool = false
    @$canvas.css "cursor", "auto" unless @_grabbing

  _onBeginGrabbing: (e) ->
    @_grabbing = true
    @_grabAnchor = gl.vec2.fromValues(e.pageX, e.pageY)
    @_initialCameraPosition = @camera.getPosition()

    @$canvas.css "cursor", "-webkit-grabbing"

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
      @$canvas.css "cursor", "-webkit-grab"
    else
      @$canvas.css "cursor", "auto"

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

    @_render()

  _onPickObject: (object) ->
    unless @_selectionBox?
      @_selectionBox = new Box()
      @sceneGizmos.add @_selectionBox

    @_selectionBox.x = object.x
    @_selectionBox.y = object.y
    @_selectionBox.width = object.radius*2
    @_selectionBox.height = object.radius*2
    @_selectionBox.material = new Material(strokeColor: "#1400E5", fillColor: "rgba(20,0,229,0.1)")

  _onUnpick: ->
    @sceneGizmos.remove @_selectionBox
    @_selectionBox = null

