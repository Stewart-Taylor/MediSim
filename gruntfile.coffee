module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json'),

        watch:
            src:
                files: ['client/**/*']
                tasks: ['client']
            gruntfile:
                files: 'gruntfile.coffee'
                options:
                    reload: true

        coffeelint:
            app: ['src/*.coffee']
            options:
                configFile: "coffeelint.json"

        coffee:
            compileJoined:
                options:
                    join: true
                files:
                    'tmp/client.js': ['client/**/*.coffee']

        clean:
            tmp:
                src: ['tmp/']




    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'


    grunt.registerTask 'client', ['clean', 'coffee', 'watch']
    grunt.registerTask 'default', ['client']

