# Basic wrapper around css classes
EasyFixtures.cssClasses =
  'bootstrap' : {
    'header' : 'page-header', 'button' : 'btn btn-default', 'input' : 'form-control',
    'inputWrapper' : 'input-group ', 'button-save' : 'btn btn-success',
    'button-delete' : 'btn btn-danger', 'infoBox' : 'lead', 'listWrapper' : 'list-group',
    'listItem' : 'list-group-item', 'label' : 'label label-primary', 'fixturesLabel' : 'label label-info',
    'errorLabel' : 'label label-danger'
  },
  'semantic-ui' : {
    'header' : 'ui header', 'sub-header' : 'sub header', 'button' : 'ui button',
    'inputWrapper' : 'ui small input', 'button-save' : 'ui green button',
    'button-delete' : 'ui red button', 'infoBox' : 'ui segment', 'listWrapper' : 'ui divided list',
    'listItem' : 'item', 'label' : 'ui small blue label', 'fixturesLabel' : 'ui teal small label',
    'errorLabel' : 'ui small red label'
  }

EasyFixtures.getCss = (what) ->
  EasyFixtures.cssClasses[EasyFixtures.cssFramework]?[what]

###
  Helper Methods
###

# Infer the structure by analyzing a single document
inferStructure = (doc) ->
  structure = []
  _.each doc, (val, docKey) ->
    if docKey != '_id'
      structure.push({ key: docKey, typeString: val.constructor.name })
  return structure

# Return the doc structure with the collection provided
getStructureByCollection = (collection) ->
  if collection?.simpleSchema?()
    schema = collection.simpleSchema().schema()
    structure = _.map schema, (val, key) ->
      if val?.type.name == 'Array'
        val.typeString = "[#{schema[key + '.$'].type.name}]"
      else
        val.typeString = val.type.name

      if key.indexOf('.$') == -1
        val.key = key
        return val

    return _.filter structure, (val) -> val
  else if collection?
    return inferStructure collection.findOne()
  else return null


createFixtures = (howMany, name) ->
  collection = EasyFixtures._collections[name]
  EasyFixtures.generateFixtures(collection,
      'structure' : getStructureByCollection(collection),
      'count' : howMany
  )


###
  Easy-Fixtures Template Methods
###

Template.easy_fixtures.created = () ->
  EasyFixtures.cssFramework = "bootstrap" if _.isFunction $.fn.collapse
  EasyFixtures.cssFramework = "semantic-ui" if _.isFunction $.fn.sidebar

Template.easy_fixtures.helpers({
  collection: () -> Session.get 'efixtures_collections',
  showOrHide: () ->
    if Session.equals('efixtures_open_config', this.toString()) then 'show' else 'hidden'
  docStructure: () -> Session.get 'efixtures_doc_structure'
  countDocs : () -> 10
  cssClass : (type) -> EasyFixtures.getCss(type)
  hasAccess: () -> EasyFixtures._collections[this.toString()]
  docsCount: () -> EasyFixtures._collections[this.toString()]?.find().count()
  fixturesCount: () ->
    EasyFixtures._collections[this.toString()]?.find({ _id : { $regex : /efixture_[\w]*/ }}).count()
})

Template.easy_fixtures.events({
  'click .collection' : () ->
    name = this.toString()

    # Define open config tab
    unless Session.equals 'efixtures_open_config', name
      Session.set 'efixtures_open_config', name
    else
      Session.set 'efixtures_open_config', null

    # Define doc structure for generating fixtures
    collection = EasyFixtures._collections[name]
    structure = getStructureByCollection(collection)

    Session.set 'efixtures_doc_structure', structure
  'click .generate' : (e) ->
    target = $(e.target)
    howMany = parseInt(target.parent().parent().find('.doc-count input').val(), 10) || 10

    EasyFixtures.clearNotifications()
    if target.hasClass 'all'
      createFixtures howMany, name for name in _.keys EasyFixtures._collections
    else
      createFixtures howMany, this.toString()
  'click .remove' : (e) ->
    collection = EasyFixtures._collections[ this.toString()]

    EasyFixtures.clearNotifications()
    if $(e.target).hasClass 'all'
      EasyFixtures.deleteFixtures collection for collection in _.values EasyFixtures._collections
    else
      EasyFixtures.deleteFixtures collection
})
