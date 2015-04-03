
class Agent

    constructor: (town, x,y) ->
        @town = town
        material = new (THREE.MeshLambertMaterial)(color: @town.color)
        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 6, 3), material)
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = false
        @cube.receiveShadow = false
        town.world.scene.add @cube

        @targetX = 40 #TODO: Determine agents target
        @targetY = 40

        @speed = 1
        @health = 100
        @strength = 1


    update: () ->
        @moveTowardsTarget()


    moveTowardsTarget: () ->

        if @x > @targetX
            @x - @speed
        else
            @x + @speed

        if @y > @targetY
            @y - @speed
        else
            @y + @speed
