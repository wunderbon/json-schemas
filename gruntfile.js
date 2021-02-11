/* istanbul ignore next */
module.exports = function (grunt) {
  'use strict';

  grunt.initConfig({
    clean: {
      options: {
        'no-write': true
      },
      generic: [
        './build/**/*'
      ]
    },
    run: {
      generic: {
        cmd: './circleci/build.sh'
      }
    },
    ts: {
      options: {
        // disable the grunt-ts fast feature
        fast: 'never'
      },
      default: {
        // specifying tsconfig as an object allows detailed configuration overrides...
        tsconfig: {
          tsconfig: './tsconfig.json',
          passThrough: true
        },
        options: {
          fast: 'never'
        }
      },
      development: {
        options: {
          fast: 'always'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-run');
  grunt.loadNpmTasks('grunt-ts');

  grunt.registerTask('default', [
    'clean', 'ts'
  ]);

  grunt.registerTask('build', [
    'clean', 'ts'
  ]);
};
