define ["jquery", "./lib/dialog", "./lib/number_input", "./lib/image_input", "two/image"], \
       ($, Dialog, NumberInput, ImageInput, Image) ->
  class Inspector extends Dialog
    constructor: (@on) ->
      super
      @hide()
      @on.objectSelected.add @_onObjectSelected, @
      @on.objectDeselected.add @_onObjectDeselected, @
      @on.objectChanged.add @_onObjectChanged, @
      @on.gizmoDragged.add @_onGizmoDragged, @
      @on.gizmoDeactivated.add @_onGizmoDeactivated, @

      @objectPositionX = new NumberInput(digits: 7, decimalPlaces: 2)
      @objectPositionY = new NumberInput(digits: 7, decimalPlaces: 2)

      @setWidth 200
      @setTranslation 50, 50

      @setTitle "Object Properties"

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
              <td>Visible</td>
              <td><input type="checkbox"/></td>
            </tr>
          </table>
        """)

      @setFooter(
        """
          <div class="panel tabs">
            <span class="tab active">Object</span>
            <span class="tab">Sprite</span>
            <span class="tab">Tab 3</span>
          </div>
        """)

      body = @getBody()
      positionRow = body.find("#inspector-object-position")
      positionRow.append @objectPositionX.domElement
      positionRow.append @objectPositionY.domElement

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

    _onGizmoDragged: ->
      @hide()
    _onGizmoDeactivated: ->
      @show()

    _copyToObject: (object) ->
      object.setName @$domElement.find(".inspector-object-name").val()
      object.setX @objectPositionX.getValue()
      object.setY @objectPositionY.getValue()

      @on.objectChanged.dispatch object

    _copyFromObject: (object) ->
      @$domElement.find(".inspector-object-name").val object.getName()
      @objectPositionX.setValue object.getX()
      @objectPositionY.setValue object.getY()

