var path = require('path');
var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');


function processSpecFiles() {
  var specRunner = pickFiles("spec", { srcDir: "/", destDir: "spec", files: ["index.html"] });
  var specLib = pickFiles("spec", { srcDir: "/lib", destDir: "spec/lib" });
  var specFiles = pickFiles("spec", { srcDir: "/src", destDir: "spec/src" });

  specFiles = filterCoffeeScript(specFiles, { bare: true });
  specFiles = filterES6Modules(specFiles, { moduleType: "amd" });

  return mergeTrees([specRunner, specLib, specFiles]);
}

var src = filterCoffeeScript('src', { bare: true });
var dependencies = pickFiles("lib", { srcDir: "/", destDir: "lib" });

spec = processSpecFiles();
src = filterES6Modules(src, { moduleType: 'amd' });

module.exports = mergeTrees([dependencies, src, spec]);
