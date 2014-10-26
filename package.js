Package.describe({
  name: 'matteodem:easy-fixtures',
  summary: "Create fixture collection data in seconds through a simple UI",
  version: "0.2.1",
  debugOnly: true,
  git: "https://github.com/matteodem/meteor-easy-fixtures.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');

  // MDG Packages
  api.use('coffeescript@1.0.0', ['client', 'server']);
  api.use(['mongo', 'templating', 'underscore', 'less', 'jquery']);

  // Community packages
  api.use(
    ['iron:router@0.9.0', 'anti:fake@0.4.1',
      'chrismbeckett:toastr@1.0.2', 'dburles:mongo-collection-instances@0.2.1']
  );

  // API Files
  api.addFiles('lib/common.coffee', ['client', 'server']);
  api.addFiles('lib/server.coffee', 'server');
  api.addFiles('lib/client.coffee', 'client');

  // Template files
  api.addFiles('templates/easy_fixtures.html');
  api.addFiles('templates/easy_fixtures.less');
  api.addFiles('templates/easy_fixtures.coffee', 'client');

  api.export('EasyFixtures');
});
