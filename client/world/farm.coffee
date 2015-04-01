
class Farm

    constructor: (town, x,y) ->

        @x = x
        @y = y

        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 1, 5), new (THREE.MeshLambertMaterial)(color: 0xd35400))
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = false
        @cube.receiveShadow = true
        town.world.scene.add @cube

        myTile = town.world.getTile(x,y)
        @value = myTile.value
        myTile.hasFarm = true
        @landValue = @value

        @active = true
