require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "signals": "../lib/signals"
    "uuid": "../lib/uuid"
    "two": "."

require ["editor/main_editor_view", "editor/db", "editor/lib/dialog"], (MainEditorView, db, Dialog) ->
  db.root.getGlobalSettings (settings) ->
    showEditor = ->
      dialog.close()
      $("body").append new MainEditorView().domElement

    if settings.mostRecentProject?
      showEditor()
    else
      dialog = new Dialog(draggable: false, resizable: false)
      dialog.setBody """
        <div>
          <div>
            <select>
              <option>Project 1</option>
              <option>Project 2</option>
              <option>Project 3</option>
            </select>
          </div>
          <button style="
              color: #0076FF;
          ">New</button>
          <button style="
              color: #0076FF;
          ">Open</button>
          <button style="
              color: white;
              background-color: rgb(230, 55, 55);
              border: none;
          ">Delete</button>
          <button id="new-project"style="
              color: #0076FF;
          ">New Project</button>
        </div>
      """

      dialog.getBody().find("#new-project").click ->


      dialog.getBody().find("button").click ->
        showEditor()

      dialog.openModal()

