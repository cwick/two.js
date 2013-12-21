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
    if settings.mostRecentProject?
      new MainEditorView().run()
    else
      dialog = new Dialog(draggable: false, resizable: false)
      dialog.setBody """
        <div><button style="
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
        <button style="
            color: #0076FF;
        ">New Project</button>
        </div>
      """
      dialog.openModal()

