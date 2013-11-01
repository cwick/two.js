define (require) ->
  $ = require "jquery"
  Dialog = require "./dialog"
  CanvasRenderer = require "./canvas_renderer"
  Scene = require "./scene"
  Camera = require "./camera"
  Disc = require "./disc"

  run: ->
    dialog = new Dialog()
    $("#editor").append dialog.$domElement

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

    renderer = new CanvasRenderer(width: $(".viewport").width(), height: $(".viewport").height())
    scene = new Scene()
    camera = new Camera(aspectRatio: renderer.getAspectRatio(), width: 10)
    scene.add new Disc(radius: 3, color: "#BE0028")

    $(".viewport").append(renderer.domElement)

    renderer.render(scene, camera)


