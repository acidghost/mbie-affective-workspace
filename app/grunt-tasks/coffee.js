/**
 * Created by acidghost on 29/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  var paths = grunt.config.get('paths');

  var appHtml = paths.app + '/scripts/app.js';
  var files = {};
  files[appHtml] = [ paths.app + '/**/*.coffee' ];

  grunt.config.merge({
    coffee: {
      compile: {
        files: files
      }
    }
  });

};
