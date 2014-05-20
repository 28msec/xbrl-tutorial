module.exports = function (grunt) {
    'use strict';

    require('load-grunt-tasks')(grunt);
   
    var path = require('path');
 
    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        'gh-pages': {
            docs: {
                src: '**/*',
                options: {
                    base: '_book'
                }
            }
        }, 
        gitbook: {
          development: {
            output: path.join(__dirname, '_book'),
            input: __dirname,
            title: 'XBRL Tutorial',
            github: '28msec/xbrl-tutorial'
          }
        },
        xqlint: {
            options: {
                src: 'queries'
            },
            dist: {}
        }
    });
    grunt.registerTask('test', ['xqlint', 'gitbook']);
    grunt.registerTask('default', ['xqlint', 'gitbook', 'gh-pages']);
};
