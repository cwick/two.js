define ["jquery", "./lib/dialog", "./key_codes"], ($, Dialog, KeyCodes) ->
  class Inspector extends Dialog
    constructor: (@on) ->
      super
      @hide()
      @on.objectSelected.add @_onObjectSelected, @
      @on.objectDeselected.add @_onObjectDeselected, @
      @on.objectChanged.add @_onObjectChanged, @

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
              <td>
                <input class="inspector-object-position-x" type="number"></input>
                <input class="inspector-object-position-y" type="number"></input>
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
                <input class="inspector-object-scale-x" type="number" />
                <input class="inspector-object-scale-y" type="number" />
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

      @$domElement.find("input").change (e) => @_onInputChanged(e)
      @$domElement.find("input").focus (e) => @_onInputFocus(e)
      @$domElement.find("input").keydown (e) => @_onInputKeydown(e)

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

    _onInputFocus: (e) ->
      window.setTimeout (-> $(e.target).select()), 0

    _onInputKeydown: (e) ->
      $(e.target).blur() if e.keyCode is KeyCodes.ENTER

    _copyToObject: (object) ->
      object.setName @$domElement.find(".inspector-object-name").val()
      object.setX parseFloat(@$domElement.find(".inspector-object-position-x").val())
      object.setY parseFloat(@$domElement.find(".inspector-object-position-y").val())
      object.setScale parseFloat(@$domElement.find(".inspector-object-scale-x").val())
      @on.objectChanged.dispatch object

    _copyFromObject: (object) ->
      @$domElement.find(".inspector-object-name").val object.getName()
      @$domElement.find(".inspector-object-position-x").val object.getX().toFixed(2)
      @$domElement.find(".inspector-object-position-y").val object.getY().toFixed(2)
      @$domElement.find(".inspector-object-scale-x").val object.getScale().toFixed(2)
      @$domElement.find(".inspector-object-scale-y").val object.getScale().toFixed(2)

