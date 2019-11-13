/* istanbul ignore next */
module.exports = function (grunt) {
  'use strict';

  grunt.initConfig({
    tslint: {
      options: {
        configuration: 'tslint.json',
        project: 'tsconfig.json',
        fix: true,
        force: true,
        quiet: true
      },
      development: {
        files: {
          src: [
            './build/ts/**/*',
            '!./build/ts/**/*.d.ts'
          ]
        }
      },
      production: {
        options: {
          configuration: 'tslint.json',
          project: 'tsconfig.json',
          fix: false
        },
        files: {
          src: [
            './build/ts/**/*',
            '!./build/ts/**/*.d.ts'
          ]
        }
      }
    },
    clean: {
      options: {
        'no-write': true,
      },
      production: [
        './build/js/*'
      ]
    },
    ts: {
      development: {
        tsconfig: 'tsconfig.json',
        options: {
          rootDir: './build',
          fast: 'always',
          removeComments: false,
          inlineSourceMap: true
        },
        src: [
          './build/ts/**/*.ts'
        ],
        outDir: './build/js'
      },
      build: {
        tsconfig: 'tsconfig.json',
        options: {
          rootDir: './src',
          fast: 'never'
        },
        src: [
          './build/ts/**/*.ts'
        ],
        outDir: '.'
      }
    },
    copy: {
      env: {
        expand: true,
        cwd: 'src/test/data',
        src: '**',
        dest: 'app/test/data/'
      }
    },
    watch: {
      ts: {
        files: ['build/ts/**/*.ts', '!./build/**/*.d.ts'],
        tasks: ['tslint:development', 'ts:development', 'move']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-prepend');
  grunt.loadNpmTasks('grunt-tslint');
  grunt.loadNpmTasks('grunt-eslint');
  grunt.loadNpmTasks('grunt-move');
  grunt.loadNpmTasks('grunt-run');
  grunt.loadNpmTasks('grunt-ts');

  grunt.registerTask('default', [
    'tslint:production', 'clean:production', 'ts:build'
  ]);

  grunt.registerTask('development', [
    'tslint:development', 'ts:development'
  ]);

  grunt.registerTask('build', [
    'tslint:production', 'clean:production', 'ts:build'
  ]);
};
