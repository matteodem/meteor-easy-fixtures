root = exports ? this

EasyFixtures = EasyFixtures || {}
EasyFixtures._collections = {}
EasyFixtures._collectionKeys = []

EasyFixtures._createDocuments = (name, conf) ->
  count = conf.count
  collection = EasyFixtures._collections[name]
  throw new Meteor.Error("No access to collection!") if not collection?

  while count > 0
    doc = EasyFixtures.getDocByStructure(conf.structure)
    doc._id = "efixture_#{new Mongo.ObjectID()._str}"
    collection.insert doc
    count -= 1

EasyFixtures.defaultData = {
  'String' : (def) ->
    str = Fake.sentence(10)
    str = str.substring(0, def.max) if def.max
    return str
  'Number' : (def) -> Math.floor((Math.random() * 11)) + 1
  'Date' : (def) -> new Date((new Date()).getTime() * Math.random())
  'Boolean' : (def) -> !!Math.floor(Math.random() + 0.5)
  # Not sure about object fixtures
  'Object' : (def) -> { 'foo' : 'bar' }
}

# Create Fixture Document by structure provided
EasyFixtures.getDocByStructure = (structure) ->
  doc = {}

  _.each structure, (def) ->
    # Is an array type
    if def.typeString[0] == '['
      doc[def.key] = []
      type = def.typeString.substring(1, def.typeString.length - 1)
      howMany = Math.floor((Math.random() * 11)) + 1
      while howMany > 0
        doc[def.key].push(EasyFixtures.defaultData[type](def))
        howMany -= 1
    else
      doc[def.key] = EasyFixtures.defaultData[def.typeString](def)

    # Remove the property if it's optional
    if def.optional and !!Math.floor(Math.random() + 0.5)
      delete doc[def.key]

  return doc

# Custom log function
log = (msg) -> console.log "EASY-FIXTURES: #{msg}"

# Setup a collection for use with the fixtures
setupCollection = (collection) ->
  name = collection.name

  EasyFixtures._collectionKeys.push(name)
  EasyFixtures._collections[name] = collection.instance

  if not EasyFixtures._collections[name]?
    log "Server side access for collection '#{name}' missing!"

# Code on startup
Meteor.startup () ->
  collections = EasyFixtures._withoutSpecialCollections(Mongo.Collection.getAll())
  setupCollection collection for collection in _.values(collections)
  Meteor.publish 'esFixturesConfiguration', () -> _.map(Mongo.Collection.getAll(), (collection) -> collection.instance.find())

# Meteor Methods
Meteor.methods({
  efixtures_collections : () -> EasyFixtures._collectionKeys
  efixtures_generate : (name, conf) ->
    check name, String
    check conf.count, Number
    check conf.structure, Array

    EasyFixtures._createDocuments(name, conf)
  efixtures_delete : (name) ->
    check name, String

    collection = EasyFixtures._collections[name]
    throw new Meteor.Error("No access to collection!") if not collection?
    collection.remove({ _id : { $regex : /efixture_[\w]*/ }})
})
