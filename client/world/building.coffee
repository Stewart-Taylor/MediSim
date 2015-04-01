

class Building

    constructor: (town, x,y) ->

        @town = town
        @x = x
        @y = y

        cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 7, 5), new (THREE.MeshLambertMaterial)(color: 0x8e44ad))
        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = false
        cube.receiveShadow = true
        town.world.scene.add cube

        myTile = town.world.getTile(x,y)
        # @value = myTile.value
        myTile.hasBuilding = true
