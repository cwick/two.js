require.config
  baseUrl: "build"
  paths:
    jquery: "../lib/jquery-2.0.3"
    "jquery.mousewheel": "../lib/jquery.mousewheel"
    "gl-matrix": "../lib/gl-matrix"
    "signals": "../lib/signals"
    "uuid": "../lib/uuid"
    "two": "."

require ["editor/main_editor_view"], (MainEditorView) ->
  new MainEditorView().run()




  # getProjectList
  # ProjectStore.getProjectList
  # ProjectStore.load

  # root
  #   projects
  #    [
  #     name
  #     id
  #    ]

  #   globalSettings
  #     mostRecentProject


  # db.root.getProjects()
  # db.root.getGlobalSettings(-> success)
  # db.root.setErrorHandler(-> error)

  # db.projects.load "foo"
