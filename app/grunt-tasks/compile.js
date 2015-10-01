/**
 * Created by acidghost on 29/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  grunt.registerTask('compile', function(){
    grunt.task.run([
      //'jade:compile',
      'coffeelint',
      'coffee',
      'less'
    ]);
  });

};
