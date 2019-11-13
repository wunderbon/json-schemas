/* istanbul ignore next */
module.exports = function (grunt) {
  'use strict';

  grunt.initConfig({
    gruntPrepend: {
      prepend : {
        options: {
          content: '#!/usr/bin/env node'
        },
        files: [{
          src: './bin/www'
        }]
      }
    },
    tslint: {
      options: {
        configuration: 'tslint.json',
        project: 'tsconfig.json',
        fix: true
      },
      development: {
        files: {
          src: [
            './src/app/**/*.ts',
            './src/bin/**/*.ts',
            './src/test/**/*.ts',
            '!./src/**/*.d.ts'
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
            './src/app/**/*.ts',
            './src/bin/**/*.ts',
            './src/test/**/*.ts',
            '!./src/**/*.d.ts',
            '!./src/app/template/tsoa/*.ts'
          ]
        }
      }
    },
    clean: {
      options: {
        'no-write': true,
      },
      production: [
        './test/*',
        '!./test/helper.js',
        '!./test/mocha.opts',
        '!./test/.env',
        './app/*',
        '!./app/swagger.json',
        '!./app/.gitkeep',
        './bin/*',
        '!./bin/.gitkeep'
      ]
    },
    ts: {
      development: {
        tsconfig: 'tsconfig.json',
        options: {
          rootDir: './src',
          fast: 'always',
          removeComments: false,
          inlineSourceMap: true
        },
        src: [
          './src/app/**/*.ts',
          './src/bin/**/*.ts',
          './src/test/**/*.ts',
        ],
        outDir: '.'
      },
      build: {
        tsconfig: 'tsconfig.json',
        options: {
          rootDir: './src',
          fast: 'never'
        },
        src: [
          './src/app/**/*.ts',
          './src/bin/**/*.ts',
          './src/test/**/*.ts',
        ],
        outDir: '.'
      }
    },
    move: {
      www: {
        options: {
          ignoreMissing: true,
        },
        src: './bin/www.js',
        dest: './bin/www'
      },
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
        files: ['src/\*\*/\*.ts', '!./src/**/*.d.ts'],
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
    'tslint:production', 'clean:production', 'ts:build', 'move:www'
  ]);

  grunt.registerTask('development', [
    'tslint:development', 'ts:development', 'move'
  ]);

  grunt.registerTask('build', [
    'tslint:production', 'clean:production', 'ts:build', 'move:www'
  ]);
};
