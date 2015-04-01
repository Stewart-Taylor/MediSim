class LevelManager


    @world = null

    constructor: (scene) ->
        @scene = scene
        console.log("Level Manager Module Loaded")



    init: ()->
        @world = new World(@scene)


        # jQuery.get '/levels/level_1.txt', (data) ->
        #     levelData = data
        #     lines = levelData.split("\n")

        #     x = 0
        #     z = 0

        #     for line in lines
        #         chars = line.split("")
        #         z = 0
        #         for char in chars
        #             if char == "#"
        #                 cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5,10, 5), new (THREE.MeshLambertMaterial)(color: 0x2c3e50))
        #             else
        #                 cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 2, 5), new (THREE.MeshLambertMaterial)(color: 0x7f8c8d))
        #             cube.position.y = 1
        #             cube.position.x = z * 5
        #             cube.position.z = x * 5
        #             cube.castShadow = true
        #             cube.receiveShadow = true
        #             scene.add cube
        #             z++
        #         x++





        # size = 10
        # x = 0
        # while x < size
        #     y = 0
        #     while y < size
        #         cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, Math.floor(Math.random() * 6) + 1, 5), new (THREE.MeshLambertMaterial)(color: 0xCC0000))
        #         cube.position.y = 1
        #         cube.position.x = x * 10
        #         cube.position.z = y * 10
        #         cube.castShadow = true
        #         cube.receiveShadow = true
        #         scene.add cube
        #         y++
        #     x++


        # plane = new (THREE.Mesh)(new (THREE.PlaneGeometry)(2000, 2000), new (THREE.MeshLambertMaterial)(color: 0xbdc3c7))
        # plane.rotation.x = 4.7123
        # @scene.add plane
        # plane.receiveShadow = true

    update: () ->
        @world.update()

