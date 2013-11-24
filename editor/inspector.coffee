define ["jquery", "./lib/dialog", "./lib/number_input"], ($, Dialog, NumberInput) ->
  class Inspector extends Dialog
    constructor: (@on) ->
      super
      @hide()
      @on.objectSelected.add @_onObjectSelected, @
      @on.objectDeselected.add @_onObjectDeselected, @
      @on.objectChanged.add @_onObjectChanged, @
      @on.gizmoDragged.add @_onGizmoDragged, @
      @on.gizmoDeactivated.add @_onGizmoDeactivated, @

      @objectPositionX = new NumberInput()
      @objectPositionY = new NumberInput()
      @objectScale = new NumberInput()

      @setWidth 200
      @setTranslation 50, 50

      @setBody(
        """
          <table>
            <tr>
              <td>Name</td>
                <td><input class="inspector-object-name" type="text" spellcheck="false"></input></td>
            </tr>
            <tr>
              <td>Parent</td>
              <td><select><option>Scene</option></select></td>
            </tr>
            <tr>
              <td>Position</td>
              <td id="inspector-object-position"></td>
            </tr>
            <tr>
              <td>Rotation</td>
              <td>
                <input class="format-degrees" type="number" value="3"></input>
              </td>
            </tr>
            <tr>
              <td>Scale</td>
              <td id="inspector-object-scale"></td>
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
                <input class="format-degrees" type="number" value="0"></input>
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

      @setFooter(
        """
          <div class="panel tabs">
            <span class="tab active">Tab 1</span>
            <span class="tab">Tab 2</span>
            <span class="tab">Tab 3</span>
          </div>
        """)

      positionRow = @getBody().find("#inspector-object-position")
      positionRow.append @objectPositionX.domElement
      positionRow.append @objectPositionY.domElement
      scaleRow = @getBody().find("#inspector-object-scale")
      scaleRow.append @objectScale.domElement

      @$domElement.find("input").change (e) => @_onInputChanged(e)

    _onObjectSelected: (object) ->
      @_object = object
      @_copyFromObject object
      @$domElement.find("input").blur()
      @show()

    _onObjectDeselected: ->
      @_object = null
      @hide()

    _onObjectChanged: (object) ->
      @_copyFromObject object if object is @_object

    _onInputChanged: (e) ->
      @_copyToObject(@_object)
      $(e.target).blur()

    _onGizmoDragged: ->
      @hide()
    _onGizmoDeactivated: ->
      @show()

    _copyToObject: (object) ->
      object.setName @$domElement.find(".inspector-object-name").val()
      object.setX @objectPositionX.getValue()
      object.setY @objectPositionY.getValue()
      object.setScale @objectScale.getValue()
      @on.objectChanged.dispatch object

    _copyFromObject: (object) ->
      @$domElement.find(".inspector-object-name").val object.getName()
      @objectPositionX.setValue object.getX()
      @objectPositionY.setValue object.getY()
      @objectScale.setValue object.getScale()

