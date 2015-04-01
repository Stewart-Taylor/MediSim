

class GameManager

    cameraManager = null
    controlManager = null
    levelManager = null
    lightManager = null
    actorManager = null


    constructor: (scene) ->

        renderer = new (THREE.WebGLRenderer)(antialias: true)
        renderer.setSize window.innerWidth, window.innerHeight
        renderer.setClearColor 0xffffff, 1
        document.body.appendChild renderer.domElement
        scene = new (THREE.Scene)

        cameraManager = new CameraManager(scene);
        controlManager = new ControlManager(scene, cameraManager);
        levelManager = new LevelManager(scene);
        lightManager = new LightManager(scene);


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


        setInterval ()->
            htmlupdate()
        ,1000


    update = ()->
        levelManager.update()



    htmlupdate = () ->
        # console.log(levelManager)
        $('#town1').html("Town 1: Pop: " + levelManager.world.towns[0].population + " food: " + levelManager.world.towns[0].food + " gold: " + levelManager.world.towns[0].gold)



