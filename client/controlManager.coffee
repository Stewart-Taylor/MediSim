

class ControlManager



    constructor: (scene, cameraManager, levelManager) ->
        @scene = scene
        @gameManager = gameManager
        @cameraManager = cameraManager
        @levelManager = levelManager
        console.log("ControlManager Module Loaded")
        console.log(@cameraManager)




        $ ->
            $('body').on 'keydown', (event) ->
                console.log event.type + ': ' + event.which
                console.log(gameManager.cameraManager)
                if event.which == 87
                    #W
                    cameraManager.camera.position.z -= 1.6
                if event.which == 83
                    #s
                    cameraManager.camera.position.z += 1.6
                if event.which == 68 #D
                    #d
                    cameraManager.camera.position.x += 1.6
                if event.which == 65 #A
                    #W
                    cameraManager.camera.position.x -= 1.6
                if event.which == 69
                    #e
                    cameraManager.camera.position.y += 1.6
                if event.which == 81
                    #W
                    cameraManager.camera.position.y -= 1.6
                if event.which == 67
                    #W
                    cameraManager.camera.rotation.x -= 0.1
                    # plane.rotation.x += 0.1;
                    # console.log(plane.rotation.x);
                if event.which == 90
                    #W
                    cameraManager.camera.rotation.x += 0.1
                # if event.which == 76
                #     #W

                #     console.log 'Camera X: ' + cameraManager.camera.position.x + ' Y: ' + cameraManager.camera.position.y + ' z: ' + cameraManager.camera.position.z
                #     console.log 'Camera ROT X: ' + cameraManager.camera.rotation.x + ' Y: ' + cameraManager.camera.rotation.y + ' z: ' + cameraManager.camera.rotation.z


                # if event.which == 75 #K
                    # levelManager.world.towns[0].population = levelManager.world.towns[0].population / 2
                    # levelManager.world.towns[0].food = levelManager.world.towns[0].food = 0

                if event.which == 80
                    #Lets Pause

                    if levelManager.paused == false
                        levelManager.paused = true
                    else
                        levelManager.paused = false


                if event.which == 38 #up
                    actorManager.player.position.z += 0.5

                if event.which == 40 #down
                    actorManager.player.position.z -= 0.5

                if event.which == 39 #right
                    actorManager.player.position.x -= 0.5

                if event.which == 37 #left
                    actorManager.player.position.x += 0.5
