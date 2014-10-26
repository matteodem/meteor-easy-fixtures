EasyFixtures = EasyFixtures || {}

EasyFixtures._specialCollections = [
  'meteor_accounts_loginServiceConfiguration',
  'efixtures_conf'
]

# Fix a collection-instances bug
if !Meteor.Collection.getAll
  Meteor.Collection = Mongo.Collection

EasyFixtures._withoutSpecialCollections = (collections) ->
  # Check if collection name is presentable to the user
  _.filter(collections, (collection) ->
    EasyFixtures._specialCollections.indexOf(collection.name) == -1
  )

# TODO: Add extended configuration at a later point
this.FixturesCollection = new Mongo.Collection('efixtures_conf')

Router.map () ->
  this.route 'easy_fixtures',
    path: '/easy-fixtures'
    waitOn: () -> Meteor.subscribe 'esFixturesConfiguration'
