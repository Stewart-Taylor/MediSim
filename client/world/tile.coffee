class Tile

    constructor: (world, x,y, value) ->

        @x = x
        @y = y
        @value = value
        @world = world
        @hasFarm = false
        @hasBuilding = false

        tileColor = new THREE.Color( 0, value, 0 );

        if type == 1
            isLand = true
        else if type = 2
            isWater = true

        cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 1, 5), new (THREE.MeshLambertMaterial)(color: tileColor))
        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = false
        cube.receiveShadow = true
        world.scene.add cube






