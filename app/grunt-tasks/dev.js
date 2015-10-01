/**
 * Created by acidghost on 30/08/15.
 */

module.exports = function (grunt) {
  'use strict';

  grunt.registerTask('dev', function(){
    grunt.task.run([
      'watch'
    ]);
  });

};
