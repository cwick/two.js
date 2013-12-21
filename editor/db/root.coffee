define (require) ->
  getGlobalSettings: (callback) ->
    @_openDB (db) ->
      request = db.transaction("globalSettings", "readonly").objectStore("globalSettings").get(1)
      request.onsuccess = (e) -> callback?(e.target.result)

  getProjects: (callback) ->
    projects = []

    @_openDB (db) ->
      store = db.transaction("projects", "readonly").objectStore("projects")
      store.openCursor().onsuccess = (e) ->
        cursor = e.target.result
        if cursor
          projects.push cursor.value
          cursor.continue()
        else
          callback(projects)

  _openDB: (callback) ->
    return callback(@db) if @db?

    request = window.indexedDB.open "root", 1
    request.onsuccess = (e) =>
      @db = e.target.result
      callback(@db)

    request.onupgradeneeded = (e) ->
      db = e.target.result
      db.createObjectStore("globalSettings").put({}, 1)
      db.createObjectStore("projects", autoIncrement: true)

