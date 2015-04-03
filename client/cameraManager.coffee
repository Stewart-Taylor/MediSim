

class CameraManager

    constructor: (scene) ->
        console.log("Camera Module Loaded")
        @camera = new (THREE.PerspectiveCamera)(60, window.innerWidth / window.innerHeight, 1, 10000)
        @camera.position.x = 138
        @camera.position.y = 103
        @camera.position.z = 170
        # camera.lookAt({x:0,y:0,z:0});
        @camera.rotation.x = -0.9
        @camera.rotation.y = 0.0
        @camera.rotation.z = 0

        scene.add @camera
