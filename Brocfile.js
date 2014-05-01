var path = require('path');
var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');

function resolveBowerDependencies(files) {
  var dependencies = files.map(function(f) {
    f = path.join("bower_components", f);
    return [path.dirname(f), path.basename(f)];
  });

  return dependencies.map(function(d) {
    var dirname = d[0];
    var filename = d[1];

    return pickFiles(dirname, {
      srcDir: "/",
      files: [filename],
      destDir: "/lib"
    });
  });
}

var src = filterCoffeeScript('src', { bare: true });
var bowerDependencies = [ "gl-matrix/dist/gl-matrix.js" ];
src = filterES6Modules(src, { moduleType: 'amd' });
bowerDependencies = resolveBowerDependencies(bowerDependencies);

module.exports = mergeTrees(bowerDependencies.concat(src));
