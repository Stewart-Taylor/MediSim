
class Farm

    constructor: (town, x,y) ->

        @x = x
        @y = y

        material = new (THREE.MeshLambertMaterial)(color: 0xd35400)
        material.transparent = true
        material.opacity = 0.5

        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 1, 3), material)
        @cube.position.y = 1.2
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


