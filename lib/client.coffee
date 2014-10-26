root = exports ? this

EasyFixtures = EasyFixtures || {}
EasyFixtures._collections = {}

EasyFixtures.generateFixtures = (collection, configuration) ->
  name = collection._name || collection.nameg
  Meteor.call('efixtures_generate', name, configuration)
  toastr.success "Added #{configuration.count} fixtures to #{name}!"

EasyFixtures.deleteFixtures = (collection) ->
  name = collection._name || collection.name
  Meteor.call('efixtures_delete', name)
  toastr.success "Removed all fixtures from #{name}!"

EasyFixtures.clearNotifications = () -> toastr.clear()

Meteor.startup () ->
  collections = EasyFixtures._withoutSpecialCollections(Mongo.Collection.getAll())

  for collection in collections
    EasyFixtures._collections[collection.name] = collection.instance

  # For use in templates
  Session.set('efixtures_collections', _.keys(EasyFixtures._collections))
