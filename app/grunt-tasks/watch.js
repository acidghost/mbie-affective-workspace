/**
 * Created by acidghost on 30/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  grunt.config.merge({
    watch: {
      coffee: {
        files: '<%= paths.app %>/**/*.coffee',
        tasks: [ 'coffeelint', 'coffee' ]
      },
      grunt: {
        files: ['Gruntfile.js', '<%= paths.gruntTasks %>/**/*.js'],
        tasks: [ 'jshint' ]
      },
      less: {
        files: '<%= paths.app %>/**/*.less',
        tasks: [ 'less' ]
      }
    }
  });

};
