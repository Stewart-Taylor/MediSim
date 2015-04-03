

class Building

    constructor: (town, color, x,y) ->

        @town = town
        @x = x
        @y = y
        @color = color

        cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 4, 3), new (THREE.MeshLambertMaterial)(color: @color))
        cube.position.y = 1
        cube.position.x = x * 5
        cube.position.z = y * 5
        cube.castShadow = true
        cube.receiveShadow = true
        town.world.scene.add cube

        myTile = town.world.getTile(x,y)
        myTile.hasBuilding = true
