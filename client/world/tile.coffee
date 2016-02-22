class Tile

    constructor: (world, x,y, value, type) ->

        @x = x
        @y = y
        @value = value
        @world = world
        @hasFarm = false
        @hasBuilding = false

        tileColor = new THREE.Color( 0, value, 0 )

        @isLand = true
        @hasOwner = false
        @owner = null

        TILE_WIDTH = 5
        TILE_HEIGHT = 5

        if type == 1
            @isLand = true
            landMaterial = new (THREE.MeshLambertMaterial)(color: tileColor)
            cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(TILE_WIDTH, 1, TILE_HEIGHT), landMaterial)
        else if type == 2
            @isLand = false
            isWater = true
            waterMaterial = new (THREE.MeshLambertMaterial)(color: 0x19B5FE)
            cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(TILE_WIDTH, 1, TILE_HEIGHT), waterMaterial)
        else if type == 3
            @isLand = false
            isWater = true
            height = Math.random() * (15 - 5) + 5
            mountainMaterial = new (THREE.MeshLambertMaterial)(color: 0x95a5a6)
            cube = new THREE.Mesh(new THREE.CylinderGeometry(0, 7, height, 10, 10, false), mountainMaterial)
        else if type == 4
            @isLand = true
            landMaterial = new (THREE.MeshLambertMaterial)(color: tileColor)
            cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(TILE_WIDTH, 1, TILE_HEIGHT), landMaterial)
        #TODO: add coastal type
        #TODO: add trees


        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = false
        cube.receiveShadow = true
        world.scene.add cube
