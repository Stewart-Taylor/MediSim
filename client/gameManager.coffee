

class GameManager

    cameraManager = null
    controlManager = null
    levelManager = null
    lightManager = null
    actorManager = null



    constructor: (scene) ->

        # gameManager = this

        renderer = new (THREE.WebGLRenderer)(antialias: true)
        renderer.setSize window.innerWidth, window.innerHeight
        renderer.setClearColor 0xffffff, 1
        document.body.appendChild renderer.domElement
        scene = new (THREE.Scene)



        # setUp = ()->
        cameraManager = new CameraManager(scene);
        controlManager = new ControlManager(scene, cameraManager);
        levelManager = new LevelManager(scene);
        lightManager = new LightManager(scene);
            # actorManager = new ActorManager(scene);





        #Used for logic updates
        # update = ()->
        #     lightManager.update()
            # actorManager.update()
            # cameraManager.camera.position.x = actorManager.player.position.x
            # cameraManager.camera.position.z = actorManager.player.position.z
            # cameraManager.camera.lookAt({x:actorManager.player.position.x,y:actorManager.player.position.y,z:actorManager.player.position.z})
            # cameraManager.camera.y += 0.78
            # cameraManager.camera.x += 1.57


        # setUp()

        # @update()

        # setInterval ()->
        #     @update()
        # , 30



        # levelManager.init()

        # document.addEventListener 'DOMContentLoaded', () ->
        #     levelManager.init()
        #     console.log(gameManager)
        #     gameManager.setUp(gameManager)
        # , false


        renderer.shadowMapEnabled = true
        renderer.shadowMapSoft = true
        renderer.shadowCameraNear = 3
        renderer.shadowCameraFar = cameraManager.camera.far
        renderer.shadowCameraFov = 50
        renderer.shadowMapBias = 0.0039
        renderer.shadowMapDarkness = 0.5
        renderer.shadowMapWidth = 1024
        renderer.shadowMapHeight = 1024

        # renderer.render scene, cameraManager.camera




        render = ->
          requestAnimationFrame render
          # cube.rotation.x += 0.1;
          # cube.rotation.y += 0.1;
          renderer.render scene, cameraManager.camera
          return

        render()



    setUp: () ->
        console.log("gManager set up")
        levelManager.init()

        setInterval ()->
            update()
        ,10


        setInterval ()->
            htmlupdate()
        ,30
        # @setUp = (gameManager) ->


        #     setInterval ()->


        #         update = () ->
        #             gameManager.levelManager.update()


        #         update()


        #     , 30

            # gameManager.update(gameManager)

    update = ()->
        # console.log("update")
        # console.log(levelManager)
        levelManager.update()



    htmlupdate = () ->
        # console.log(levelManager)
        $('#town1').html("Town 1: Pop: " + levelManager.world.towns[0].population + " food: " + levelManager.world.towns[0].food + " gold: " + levelManager.world.towns[0].gold)



