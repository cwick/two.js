var path = require('path');
var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');

// function resolveDependencies(files) {
//   var dependencies = files.map(function(f) {
//     f = path.join("lib", f);
//     return [path.dirname(f), path.basename(f)];
//   });
//
//   return dependencies.map(function(d) {
//     var dirname = d[0];
//     var filename = d[1];
//
//     return pickFiles(dirname, {
//       srcDir: "/",
//       files: [filename],
//       destDir: "/lib"
//     });
//   });
// }

var src = filterCoffeeScript('src', { bare: true });
var dependencies = pickFiles("lib", { srcDir: "/", destDir: "lib" });
var specRunner = pickFiles("spec", { srcDir: "/", destDir: "spec", files: ["index.html"] });
var specLib = pickFiles("spec", { srcDir: "/lib", destDir: "spec/lib" });
var specFiles = pickFiles("spec", { srcDir: "/src", destDir: "spec/src" });

specFiles = filterCoffeeScript(specFiles, { bare: true });
specFiles = filterES6Modules(specFiles, { moduleType: "amd" });

spec = [specRunner, specLib, specFiles];

src = filterES6Modules(src, { moduleType: 'amd' });

module.exports = mergeTrees([dependencies, src].concat(spec));
