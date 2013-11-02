define (require) ->
  $ = require "jquery"
  require "jquery.mousewheel"
  Dialog = require "./dialog"
  CanvasRenderer = require "./canvas_renderer"
  Scene = require "./scene"
  Camera = require "./camera"
  Disc = require "./disc"
  KeyCodes = require "./key_codes"
  MouseButtons = require "./mouse_buttons"
  gl = require "gl-matrix"

  run: ->
    dialog = new Dialog()
    $("#editor").append dialog.$domElement
    @$viewport = $(".viewport")

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

    @renderer = new CanvasRenderer(width: @$viewport.width(), height: @$viewport.height())
    @scene = new Scene()
    @camera = new Camera(screenWidth: @renderer.getWidth(), screenHeight: @renderer.getHeight())

    @scene.add new Disc(radius: 3, color: "#BE0028")

    @$viewport.append(@renderer.domElement)

    @maxCameraWidth = 1000
    @minCameraWidth = 1
    @zoomSpeed = 1

    @_render()

    $(document).on "keydown keyup mousedown mouseup mousemove mousewheel", => @_onUserInput.apply @, arguments

  _render: ->
    @renderer.render(@scene, @camera)

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
    if e.which == MouseButtons.LEFT && @_grabTool
      return @_onBeginGrabbing(e) || true

  _onMouseup: (e) ->
    if e.which == MouseButtons.LEFT && @_grabbing
      return @_onStopGrabbing(e) || true

  _onMousemove: (e) ->
    if e.which == MouseButtons.LEFT && @_grabbing
      return @_onGrabbing(e) || true

  _onMousewheel: (e, delta) ->
    return @_onZoom(delta*0.006)

  _onGrabToolSelected: ->
    @_grabTool = true
    @$viewport.css "cursor", "-webkit-grab"

  _onStopGrab: ->
    @_grabTool = false
    @$viewport.css "cursor", "auto" unless @_grabbing

  _onBeginGrabbing: (e) ->
    @_grabbing = true
    @_grabAnchor = gl.vec2.fromValues(e.offsetX, e.offsetY)
    @_initialCameraPosition = @camera.getPosition()

    @$viewport.css "cursor", "-webkit-grabbing"

  _onGrabbing: (e) ->
    grabPoint = gl.vec2.fromValues(e.offsetX, e.offsetY)
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
      @$viewport.css "cursor", "-webkit-grab"
    else
      @$viewport.css "cursor", "auto"

  _onZoom: (amount) ->
    width = @camera.getWidth()
    width -= amount*@zoomSpeed*width
    width = Math.min(width, @maxCameraWidth)
    width = Math.max(width, @minCameraWidth)

    @camera.setWidth(width)
    @_render()

