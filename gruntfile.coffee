module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json'),

        watch:
            src:
                files: ['client/**/*', 'public/style.css', 'views/**/*.ejs']
                tasks: ['client']
            gruntfile:
                files: 'gruntfile.coffee'
                options:
                    reload: true

        coffeelint:
            app: ['client/**/*.coffee']
            options:
                configFile: "coffeelint.json"

        coffee:
            compileJoined:
                options:
                    join: true
                files:
                    'static/tmp/client.js': ['client/**/*.coffee']

        clean:
            tmp:
                src: ['tmp/']

        todo:
            src: ['client/**/*.coffee']

        'http-server':
            port:8080
            root: 'static'



    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-todo'
    grunt.loadNpmTasks 'grunt-http-server'



    grunt.registerTask 'client', ['clean', 'coffeelint' , 'coffee', 'todo', 'watch']
    grunt.registerTask 'default', ['client']

