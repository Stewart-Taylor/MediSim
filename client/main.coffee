




gameManager = new GameManager()



document.addEventListener 'DOMContentLoaded', () ->
    console.log("dom loaded")
    console.log(gameManager)
    gameManager.setUp()
    # levelManager.init()
    # console.log(gameManager)
    # gameManager.setUp(gameManager)
, false

# renderer = new (THREE.WebGLRenderer)(antialias: true)
# renderer.setSize window.innerWidth, window.innerHeight
# renderer.setClearColor 0xffffff, 1
# document.body.appendChild renderer.domElement
# scene = new (THREE.Scene)


# cameraManager = null
# controlManager = null
# levelManager = null
# lightManager = null
# actorManager = null

# setUp = ()->
#     cameraManager = new CameraManager(scene);
#     controlManager = new ControlManager(scene, cameraManager);
#     levelManager = new LevelManager(scene);
#     lightManager = new LightManager(scene);
#     # actorManager = new ActorManager(scene);





# #Used for logic updates
# update = ()->
#     lightManager.update()
#     # actorManager.update()
#     # cameraManager.camera.position.x = actorManager.player.position.x
#     # cameraManager.camera.position.z = actorManager.player.position.z
#     # cameraManager.camera.lookAt({x:actorManager.player.position.x,y:actorManager.player.position.y,z:actorManager.player.position.z})
#     # cameraManager.camera.y += 0.78
#     # cameraManager.camera.x += 1.57


# setUp()



# setInterval ()->
#     update()
# , 30








# renderer.shadowMapEnabled = true
# renderer.shadowMapSoft = true
# renderer.shadowCameraNear = 3
# renderer.shadowCameraFar = cameraManager.camera.far
# renderer.shadowCameraFov = 50
# renderer.shadowMapBias = 0.0039
# renderer.shadowMapDarkness = 0.5
# renderer.shadowMapWidth = 1024
# renderer.shadowMapHeight = 1024

# # renderer.render scene, cameraManager.camera




# render = ->
#   requestAnimationFrame render
#   # cube.rotation.x += 0.1;
#   # cube.rotation.y += 0.1;
#   renderer.render scene, cameraManager.camera
#   return

# render()




# levelManager.init()

