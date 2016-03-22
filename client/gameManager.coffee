

class GameManager

    cameraManager = null
    controlManager = null
    levelManager = null
    lightManager = null
    stats = null


    constructor: (scene) ->


        renderer = new (THREE.WebGLRenderer)(antialias: true)
        renderer.setSize window.innerWidth, window.innerHeight
        renderer.setClearColor 0xffffff, 1
        document.body.appendChild renderer.domElement
        scene = new (THREE.Scene)

        cameraManager = new CameraManager(scene)
        levelManager = new LevelManager(scene)
        controlManager = new ControlManager(scene, cameraManager, levelManager) #TODO: only pass GameManager
        lightManager = new LightManager(scene)


        renderer.shadowMapEnabled = true
        renderer.shadowMapSoft = true
        renderer.shadowCameraNear = 3
        renderer.shadowCameraFar = cameraManager.camera.far
        renderer.shadowCameraFov = 50
        renderer.shadowMapBias = 0.0039
        renderer.shadowMapDarkness = 0.5
        renderer.shadowMapWidth = 1024
        renderer.shadowMapHeight = 1024


        render = ->
            requestAnimationFrame render
            renderer.render scene, cameraManager.camera
            return

        render()



    setUp: () ->
        levelManager.init()

        setInterval ()->
            update()
        ,10


        setInterval () ->
            htmlupdate()
        ,100


    update = () ->
        timestart = Date.now()
        levelManager.update()
        timeTaken = Date.now() - timestart


    htmlupdate = () ->
        # console.log(levelManager)

        i = 0
        while i < levelManager.world.towns.length
            color = levelManager.world.towns[i].color

            $('#town_' + (i + 1) + "_color").css( "background", "#" + color.toString(16) );
            # $('#town_' + (i + 1) + "_pop").html("Pop:" + Math.floor(levelManager.world.towns[i].population) + "  ")
            $('#town_' + (i + 1) + "_pop").html("Pop:" + Math.floor(levelManager.world.towns[i].population)  ) # + "  Tech: " + levelManager.world.towns[i].technologyFactor.toFixed(3) )
            # $('#town_' + (i + 1) + "_food").html("Food:" + Math.floor(levelManager.world.towns[i].food) + " | ")
            # $('#town_' + (i + 1) + "_foodDiff").html("FoodDiff:" + Math.floor(levelManager.world.towns[i].foodDif) + " | ")
            # $('#town_' + (i + 1) + "_gold").html("Gold:" + Math.floor(levelManager.world.towns[i].gold) + " | ")
            # $('#town_' + (i + 1) + "_agents").html("Agents:" + Math.floor(levelManager.world.towns[i].getAgentCount()) )
            i++

        # $('#town1').html("Town 1: Pop: " + levelManager.world.towns[0].population + " food: " + levelManager.world.towns[0].food + " foodDif: " + levelManager.world.towns[0].foodDif +  " gold: " + levelManager.world.towns[0].gold + " Agents: " + levelManager.world.towns[0].getAgentCount())

        # $('#town1').html("Town 1: Pop: " + levelManager.world.towns[0].population + " food: " + levelManager.world.towns[0].food + " foodDif: " + levelManager.world.towns[0].foodDif +  " gold: " + levelManager.world.towns[0].gold + " Agents: " + levelManager.world.towns[0].getAgentCount())


