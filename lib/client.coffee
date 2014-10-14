root = exports ? this

EasyFixtures = EasyFixtures || {}
EasyFixtures._collections = {}

EasyFixtures.generateFixtures = (collection, configuration) ->
  name = collection._name || collection.name
  Meteor.call('efixtures_generate', name, configuration)
  toastr.success "Added #{configuration.count} fixtures to #{name}!"

EasyFixtures.deleteFixtures = (collection) ->
  name = collection._name || collection.name
  Meteor.call('efixtures_delete', name)
  toastr.success "Removed all fixtures from #{name}!"

EasyFixtures.clearNotifications = () -> toastr.clear()

Meteor.subscribe 'esFixturesConfiguration'

Meteor.startup () ->
  Meteor.call 'efixtures_collections', (e, collections) ->
    for name in collections
      collection = null

      # Search root scope
      for key, value of root
        if name == value?._name
          collection = value

      EasyFixtures._collections[name] = collection if not EasyFixtures._collections[name]

    # For use in templates
    Session.set('efixtures_collections', _.keys(EasyFixtures._collections))
