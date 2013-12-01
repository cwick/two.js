define (require) ->
  Color = require "./color"
  Image = require "./image"
  Utils = require "./utils"

  materialImporters = {}
  materialImporters.MaterialImporter = class
    import: (data) ->
      imported = Utils.merge {}, data
      delete imported.type
      imported

    makeColor: (color) ->
      new Color(r: color[0], g: color[1], b: color[2], a: color[3])

  materialImporters.ShapeMaterialImporter = class extends materialImporters.MaterialImporter
    import: (data) ->
      imported = super
      imported.fillColor = @makeColor data.fillColor
      imported.strokeColor = @makeColor data.strokeColor
      imported

  materialImporters.SpriteMaterialImporter = class extends materialImporters.ShapeMaterialImporter
    import: (data) ->
      imported = super
      imported.image = new Image(data.image)
      imported

  materialImporters.SceneMaterialImporter = class extends materialImporters.MaterialImporter
    import: (data) ->
      imported = super
      imported.backgroundColor = @makeColor data.backgroundColor
      imported

  class ObjectImporter
    import: (data) ->
      materialList = {}
      objectList = {}

      materialList[m.id] = @_importMaterial(m) for m in data.materialList
      objectList[o.id] = @_importObject(o, materialList) for o in data.objectList

      @_createObjectTree objectList, data.objectList

    _importMaterial: (data) ->
      Importer = materialImporters["#{data.type}Importer"]
      throw new Error("Unknown material type #{data.type}") unless Importer?

      Material = require @_getModuleName(data.type)
      new Material(new Importer().import data)

    _importObject: (data, materialList) ->
      imported = Utils.merge {}, data
      imported.material = materialList[data.material]
      delete imported.children
      delete imported.type

      Object = require @_getModuleName(data.type)
      new Object(imported)

    _getModuleName: (type) ->
      name = type.replace(/([A-Z])/g, (x) -> "_#{x.toLowerCase()}")[1..]
      "./#{name}"

    _createObjectTree: (objectList, objectData) ->
      for data in objectData
        for childID in data.children
          child = objectList[childID]
          throw new Error("Missing object #{childID}") unless child?
          objectList[data.id].add child

      root = (o for _,o of objectList when o.getParent() is null)
      throw new Error("No root node found") if root.length == 0
      throw new Error("Multiple root nodes found") if root.length != 1
      root[0]
