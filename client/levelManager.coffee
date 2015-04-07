class LevelManager



    constructor: (scene) ->
        @world = null
        @scene = scene
        @paused = false
        console.log("Level Manager Module Loaded")

    init: ()->
        @world = new World(@scene)


    update: () ->
        if @paused == false
            @world.update()

