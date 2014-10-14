Package.describe({
  name: 'matteodem:easy-fixtures',
  summary: "Create fixture data for your collections through a simple interface",
  version: "0.2.0",
  git: " \* Fill me in! *\ "
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');

  // MDG Packages
  api.use('coffeescript@1.0.0', ['client', 'server']);
  api.use(['mongo', 'templating', 'underscore', 'less', 'jquery']);

  // Community packages
  api.use(['iron:router@0.9.0', 'anti:fake@0.4.1', 'chrismbeckett:toastr@1.0.2']);

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

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('easy-fixtures');
  api.addFiles('easy-fixtures-tests.js');
});
