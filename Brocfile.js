var path = require('path');
var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');

function processCoffeeFiles(tree) {
  tree = filterCoffeeScript(tree, { bare: true });
  tree = filterES6Modules(tree, { moduleType: 'amd' });
  return tree;
}

function processSpecFiles() {
  var specRunner = pickFiles("spec", { srcDir: "/", destDir: "spec", files: ["index.html"] });
  var specLib = pickFiles("spec", { srcDir: "/lib", destDir: "spec/lib" });
  var specFiles = pickFiles("spec", { srcDir: "/src", destDir: "spec/src" });

  specFiles = processCoffeeFiles(specFiles);

  return mergeTrees([specRunner, specLib, specFiles]);
}

var src = processCoffeeFiles("src");
var dependencies = pickFiles("lib", { srcDir: "/", destDir: "lib" });
var demo = [
  pickFiles("demo", { srcDir: "/", destDir: "/", files: ["index.html"] }),
  pickFiles("demo", { srcDir: "/", destDir: "/demo", files: ["require_config.js"] }),
  pickFiles("demo", { srcDir: "/", destDir: "/demo", files: ["*.html"] }),
  processCoffeeFiles(pickFiles("demo", { srcDir: "/", destDir: "/demo", files: ["**/*.coffee"] }))
];

spec = processSpecFiles();

module.exports = mergeTrees([dependencies, src, spec].concat(demo));
