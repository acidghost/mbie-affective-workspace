module.exports = function (grunt) {
  'use strict';

  grunt.config.merge({
    clean: {
      'Linux64_v0.12.3': {
        files: [{
          dot: true,
          src: ['<%= paths.dist %>/Linux64_v0.12.3/*']
        }]
      }
    },
    copy: {
      'Linux64_v0.12.3': {
        options: {
          mode: true
        },
        files: [
          {
            expand: true,
            cwd: '<%= paths.nwjsSource %>/nwjs-v0.12.3-linux-x64',
            dest: '<%= paths.dist %>/Linux64_v0.12.3',
            src: 'nw.pak'
          },
          {
            expand: true,
            cwd: '<%= paths.nwjsSource %>/nwjs-v0.12.3-linux-x64',
            dest: '<%= paths.dist %>/Linux64_v0.12.3',
            src: 'nw'
          },
          {
            expand: true,
            cwd: '<%= paths.nwjsSource %>/nwjs-v0.12.3-linux-x64',
            dest: '<%= paths.dist %>/Linux64_v0.12.3',
            src: 'nw.dat'
          },
          {
            expand: true,
            cwd: '<%= paths.nwjsSource %>/nwjs-v0.12.3-linux-x64',
            dest: '<%= paths.dist %>/Linux64_v0.12.3',
            src: 'icudtl.dat'
          },
          {
            expand: true,
            cwd: '<%= paths.app %>',
            dest: '<%= paths.dist %>/Linux64_v0.12.3/app.nw',
            src: [ '**/*.json', '**/*.js', '**/*.html', '**/*.jade', '**/*.css' ]
          }
        ]
      }
    }
  });

  grunt.registerTask('Linux64_v0.12.3', function(){
    grunt.task.run([
      'clean:Linux64_v0.12.3',
      'compile',
      'copy:Linux64_v0.12.3'
    ]);
  });

};
