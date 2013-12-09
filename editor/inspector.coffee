define ["jquery", "./lib/dialog", "./lib/number_input"], \
       ($, Dialog, NumberInput) ->
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
      @objectWidth = new NumberInput(digits: 7, decimalPlaces: 2)
      @objectHeight = new NumberInput(digits: 7, decimalPlaces: 2)
      @objectOriginX = new NumberInput(digits: 7, decimalPlaces: 2)
      @objectOriginY = new NumberInput(digits: 7, decimalPlaces: 2)

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
              <td>Origin</td>
              <td id="inspector-object-origin"></td>
            </tr>
            <tr>
              <td>Size</td>
              <td id="inspector-object-size"></td>
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

      sizeRow = body.find("#inspector-object-size")
      sizeRow.append @objectWidth.domElement
      sizeRow.append @objectHeight.domElement

      originRow = body.find("#inspector-object-origin")
      originRow.append @objectOriginX.domElement
      originRow.append @objectOriginY.domElement

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
      object.setSize @objectWidth.getValue(), @objectHeight.getValue()
      object.setOrigin [@objectOriginX.getValue(), @objectOriginY.getValue()]

      @on.objectChanged.dispatch object

    _copyFromObject: (object) ->
      @$domElement.find(".inspector-object-name").val object.getName()
      @objectPositionX.setValue object.getX()
      @objectPositionY.setValue object.getY()
      @objectWidth.setValue object.getWidth()
      @objectHeight.setValue object.getHeight()
      @objectOriginX.setValue object.getOrigin()[0]
      @objectOriginY.setValue object.getOrigin()[1]

