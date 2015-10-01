/**
 * Created by acidghost on 29/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  var paths = grunt.config.get('paths');

  var appHtml = paths.app + '/app.html';
  var files = {};
  files[appHtml] = [ paths.app + '/**/*.jade' ];

  grunt.config.merge({
    jade: {
      compile: {
        options: {
          data: {
            debug: true
          }
        },
        files: [ {
          expand: true,
          src: '**/*.jade',
          dest: '<%= paths.app%>/',
          cwd: '<%= paths.app %>',
          ext: '.html'
        }]
      }
    }
  });

};
