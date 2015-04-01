class LightManager

    constructor: (scene) ->
        console.log("Light Manager Module Loaded")


        scene.add new (THREE.AmbientLight)(0x212223)

        @spotLight = new THREE.SpotLight( 0xffffff )
        @spotLight.position.set( 350, 250, 150 )
        @spotLight.castShadow = true
        @spotLight.shadowMapWidth = 2048
        @spotLight.shadowMapHeight = 2048
        @spotLight.shadowCameraNear = 500
        @spotLight.shadowCameraFar = 4000
        @spotLight.shadowCameraFov = 30
        @spotLight.shadowBias = 0.0001
        @spotLight.shadowDarkness = 0.2

        scene.add @spotLight


    update: ()->
        # @light.rotation.y += 0.1
        # @spotLight.position.y += 1
