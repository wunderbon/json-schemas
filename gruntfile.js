/* istanbul ignore next */
module.exports = function (grunt) {
  'use strict';

  grunt.initConfig({
    run: {
      generic: {
        cmd: './circleci/build.sh'
      }
    },
    ts: {
      options: {
        fast: 'always'
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
          fast: 'never'
        }
      }
    },
    hashFileContents: {
      algorithm: 'md5',
      encoding: 'hex',
      files: [
        'npm-shrinkwrap.json',
        '.circleci/config.yml'
      ],
      target: 'hash'
    }
  });

  grunt.loadNpmTasks('grunt-hash-file-contents');
  grunt.loadNpmTasks('grunt-run');
  grunt.loadNpmTasks('grunt-ts');

  grunt.registerTask('default', [
    'ts'
  ]);

  grunt.registerTask('build', [
    'ts', 'hashFileContents'
  ]);
};
