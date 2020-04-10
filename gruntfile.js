/* istanbul ignore next */
module.exports = function (grunt) {
  'use strict';

  grunt.initConfig({
    clean: {
      options: {
        'no-write': false,
      },
      generic: [
        './build/**/*'
      ]
    },
    run: {
      generic: {
        cmd: './circleci/build.sh'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-run');

  grunt.registerTask('default', [
    'clean', 'run'
  ]);

  grunt.registerTask('build', [
    'clean', 'run'
  ]);
};
