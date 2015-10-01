/**
 * Created by acidghost on 30/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  grunt.config.merge({
    less: {
      dev: {
        files: {
          '<%= paths.app %>/styles/style.css': '<%= paths.app %>/styles/style.less'
        }
      }
    }
  });

};
