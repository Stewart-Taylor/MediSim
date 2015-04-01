

class Building

    constructor: (town, x,y) ->

        @town = town
        @x = x
        @y = y

        cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 4, 3), new (THREE.MeshLambertMaterial)(color: 0x34495e))
        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = true
        cube.receiveShadow = true
        town.world.scene.add cube

        myTile = town.world.getTile(x,y)
        # @value = myTile.value
        myTile.hasBuilding = true
