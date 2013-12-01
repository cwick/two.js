define ->
  materialExporters = {}
  materialExporters.MaterialExporter = class
    export: (material) ->
      data = material.cloneProperties()
      data.id = material.getId()
      data

  materialExporters.ShapeMaterialExporter = class extends materialExporters.MaterialExporter
    export: (material) ->
      data = super
      data.fillColor = material.fillColor.toArray()
      data.strokeColor = material.strokeColor.toArray()
      data

  materialExporters.SpriteMaterialExporter = class extends materialExporters.ShapeMaterialExporter
    export: (material) ->
      data = super
      data.image = material.image.getPath()
      data

  class ObjectExporter
    export: (object) ->
      objectList = []
      materialList = {}

      @_export object, objectList, materialList

      {
        objectList: objectList
        materialList: (v for _,v of materialList)
      }

    _export: (object, objectList, materialList) ->
      objectList.push @_exportObject(object, materialList)

      @_export o, objectList, materialList for o in object.getChildren()


    _exportObject: (object, materialList) ->
      data = object.cloneProperties()
      data.id = object.getId()
      data.children = (c.getId() for c in object.getChildren())
      data.type = object.constructor.name

      delete data.parent

      material = object.getMaterial()
      if material?
        materialList[material.getId()] ?= @_exportMaterial(material)
        data.material = material.getId()

      data

    _exportMaterial: (material) ->
      Exporter = materialExporters["#{material.constructor.name}Exporter"]
      throw Error("Unknown material type #{material.constructor.name}") unless Exporter?

      new Exporter().export material
