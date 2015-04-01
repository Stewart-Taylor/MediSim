class LevelManager


    @world = null

    constructor: (scene) ->
        @scene = scene
        console.log("Level Manager Module Loaded")

    init: ()->
        @world = new World(@scene)


    update: () ->
        @world.update()

