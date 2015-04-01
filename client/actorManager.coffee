class ActorManager

    constructor: (scene) ->
        console.log("Actor Manager Module Loaded")

        @player = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 6, 3), new (THREE.MeshLambertMaterial)(color: 0x3498db))
        @player.position.y = 2
        @player.position.x = 5
        @player.position.z = 5
        @player.castShadow = true
        @player.receiveShadow = true
        scene.add @player


    update: () ->
        # @player.rotation.x += 0.2
        # @player.rotation.y += 0.01
        # @player.rotation.z += 0.2
