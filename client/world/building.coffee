

class Building

    constructor: (town, color, x,y) ->

        @town = town
        @x = x
        @y = y
        @color = color


        # height = Math.random() * (5 - 2) + 2
        height = 4


        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, height, 3), new (THREE.MeshLambertMaterial)(color: @color))
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = true
        @cube.receiveShadow = true
        @town.world.scene.add @cube

        @myTile = @town.world.getTile(x,y)
        @myTile.hasBuilding = true
        @active = true


    destroy: () ->

        @town.world.scene.remove(@cube)
        @myTile.hasBuilding = false
        @myTile.hasFarm = true
        @active = false
