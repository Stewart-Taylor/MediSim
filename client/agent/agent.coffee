
class Agent

    constructor: (town,targetTown, x,y) ->
        @town = town
        @targetTown = targetTown
        material = new (THREE.MeshLambertMaterial)(color: @town.color)
        @cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(1, 3, 1), material)
        @cube.position.y = 3
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = false
        @cube.receiveShadow = false
        town.world.scene.add @cube

        @targetX = @targetTown.x
        @targetY = @targetTown.y

        @x = x
        @y = y

        @speed = 0.01
        @health = 1000
        @strength = 1

        @active = true


    update: () ->
        if @active == true
            @moveTowardsTarget()


    moveTowardsTarget: () ->

        if @health <= 0
            @active = false
            @cube.position.y = -5


        xd = Math.abs(@x - @targetX)
        yd = Math.abs(@y - @targetY)
        if xd < 2 && yd < 2
            @health -= 1
            @targetTown.population -= 1
            if @targetTown.population < 0
                @targetTown.population = 0
                @targetTown.id = @town.id
                @targetTown.color = @town.color
                @targetTown.cube.material = @town.cube.material
                @targetTown.population = 0
                @targetTown.food = 0
                @targetTown.gold = 0
                @active = false
                @cube.position.y = -5

                for building in @targetTown.buildings
                    building.cube.material = @town.cube.material
        else
            if @x > @targetX
                @x -= @speed
            else
                @x += @speed

            if @y > @targetY
                @y -= @speed
            else
                @y += @speed

            @cube.position.x = @x * 5
            @cube.position.z = @y * 5
