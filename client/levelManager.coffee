class LevelManager


    @world = null


    constructor: (scene) ->
        @scene = scene
        @paused = false
        console.log("Level Manager Module Loaded")

    init: ()->
        @world = new World(@scene)


    update: () ->
        console.log("paused: " , @paused)
        if @paused == false
            @world.update()

