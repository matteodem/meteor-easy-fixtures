EasyFixtures = EasyFixtures || {}

EasyFixtures.addCollection = (collection) ->
  EasyFixtures._collectionKeys.push(collection._name) if EasyFixtures._collectionKeys?
  EasyFixtures._collections[collection._name] = collection


# TODO: Add extended configuration at a later point
this.FixturesCollection = new Meteor.Collection 'efixtures_conf'

Router.map () ->
  this.route 'easy_fixtures',
    path: '/easy-fixtures'
