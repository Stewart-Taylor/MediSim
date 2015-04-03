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

        if type == 1
            @isLand = true
            cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(5, 1, 5), new (THREE.MeshLambertMaterial)(color: tileColor))
        else if type == 2
            @isLand = false
            isWater = true
            cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(5, 1, 5), new (THREE.MeshLambertMaterial)(color: 0x19B5FE))

        else if type == 3
            @isLand = false
            isWater = true
            height = Math.random() * (15 - 5) + 5
            cube = new THREE.Mesh(new THREE.CylinderGeometry(0, 7, height, 10, 10, false), new (THREE.MeshLambertMaterial)(color: 0x95a5a6))

        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = false
        cube.receiveShadow = true
        world.scene.add cube
