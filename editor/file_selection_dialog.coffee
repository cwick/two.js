define ["jquery", "./lib/dialog", "./key_codes"], ($, Dialog, KeyCodes) ->
  class FileSelectionDialog extends Dialog
    constructor: ->
      super draggable: false, resizable: false
      @setTitle "Open Project"

      $(document).on "keydown.modal", (e) =>
        if e.keyCode == KeyCodes.ESCAPE
          @close()
          $(document).off "keydown.modal"

      @setBody """
        <select>
        </select>
      """

    openModal: ->
      super
      request = indexedDB.open "projects", 1
      request.onsuccess = =>
        db = request.result
        db.onerror = (e) -> console.error e
        db.transaction("projects").objectStore("projects").index("name").openKeyCursor().onsuccess = (e) =>
          cursor = e.target.result
          if cursor
            @getBody().append $("<option/>", html: cursor.key, value: cursor.primaryKey)
            cursor.continue()


    _createDB: ->
      db = null
      request = indexedDB.open "projects", 1
      request.onerror = (-> alert "Error opening DB: #{request.error.name}")
      request.onupgradeneeded = (e) ->
        db = e.target.result
        store = db.createObjectStore "projects", autoIncrement: true
        store.createIndex "name", "name", unique: false

      request.onsuccess = ->
        db = request.result
        db.onerror = (e) -> console.error e
        db.transaction("projects", "readwrite").objectStore("projects").put(
          name: "test project 3", scene: JSON.parse(localStorage.getItem "scene")).onsuccess = -> console.log 'success'

