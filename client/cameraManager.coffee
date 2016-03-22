

class CameraManager

    constructor: (scene) ->
        fov = 60
        aspect = window.innerWidth / window.innerHeight
        near = 1
        far = 10000

        @camera = new (THREE.PerspectiveCamera)(fov, aspect, near, far)
        @camera.position.x = 138
        @camera.position.y = 103
        @camera.position.z = 170
        @camera.rotation.x = -0.9
        @camera.rotation.y = 0.0
        @camera.rotation.z = 0

        scene.add @camera
