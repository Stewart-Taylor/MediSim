class LevelManager



    constructor: (scene) ->
        @world = null
        @scene = scene
        @paused = false

    init: ()->
        @world = new World(@scene)


    update: () ->
        if @paused == false
            @world.update()

