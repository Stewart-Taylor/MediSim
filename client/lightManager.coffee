class LightManager

    constructor: (scene) ->
        x = 90
        y = 500
        z = 20

        scene.add new (THREE.AmbientLight)(0x212223)

        @spotLight = new THREE.DirectionalLight( 0xffffffd)
        @spotLight.position.set( 1, 1, 0 )

        @spotLight.castShadow = false
        @spotLight.shadowCameraVisible = true
        # @spotLight.shadowMapWidth = 1048
        # @spotLight.shadowMapHeight = 1048
        # @spotLight.shadowCameraNear = 500
        # @spotLight.shadowCameraFar = 4000
        # @spotLight.shadowCamerwaFov = 30
        # @spotLight.shadowBias = 0.0001
        # @spotLight.shadowDarkness = 0.9



        scene.add @spotLight
