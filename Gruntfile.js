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
                    base: '_book',
                    repo: 'https://' + process.env.GH_TOKEN + '@github.com/28msec/xbrl-tutorial.git',
                    silent: true
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
        },
        shell: {
            zorba: {
                options: {
                    stderr: false
                },
                command: 'zorba -q build-book.xq -f'
            }
        }
    });
    
    grunt.registerTask('deploy', function() {
        if(process.env.TRAVIS_BRANCH === 'master' && process.env.TRAVIS_PULL_REQUEST === 'false') {
            grunt.task.run(['gh-pages']);
        }
    });
 
    grunt.registerTask('default', ['xqlint', 'shell', 'gitbook', 'deploy']);
};
