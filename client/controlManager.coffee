

class ControlManager

    constructor: (scene, cameraManager, levelManager) ->
        @scene = scene
        @gameManager = gameManager
        @cameraManager = cameraManager
        @levelManager = levelManager


        $ ->
            $('body').on 'keydown', (event) ->
                console.log event.type + ': ' + event.which
                if event.which == 87 #W
                    cameraManager.camera.position.z -= 1.6
                if event.which == 83 #S
                    cameraManager.camera.position.z += 1.6
                if event.which == 68 #D
                    cameraManager.camera.position.x += 1.6
                if event.which == 65 #A
                    cameraManager.camera.position.x -= 1.6
                if event.which == 69 #E
                    cameraManager.camera.position.y += 1.6
                if event.which == 81 #Q
                    cameraManager.camera.position.y -= 1.6
                if event.which == 67 #C
                    cameraManager.camera.rotation.x -= 0.1
                if event.which == 90 #Z
                    cameraManager.camera.rotation.x += 0.1
                if event.which == 80 #P
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
