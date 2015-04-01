class Town


    constructor: (world, x,y) ->

        @world = world
        @population = 10
        @food = 100
        @gold = 70
        @farmPrice = 100
        @buildings = []

        @farms = []
        @x = x
        @y = y


        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 10, 5), new (THREE.MeshLambertMaterial)(color: 0x2c3e50))
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = false
        @cube.receiveShadow = true
        world.scene.add @cube



        # @buyFarm()


    update: () ->
        # @population += 1
        @food += @calculateFood()
        foodDif = @food - @population
        # if foodDif == 0
        #     console.log("")
        #     @population = @population / 2
        if foodDif < 0
            @population += foodDif
            @food = 0
        else
            @food = @food - @population
            @population += @population + 1


        # if @food
        # @cube.position.y += 0.1

        @gold = @gold + @population / 2

        if @gold > @farmPrice
            @buyFarm()

    buyFarm: () ->

        bestTile = @findBestFarmTile()


        console.log(bestTile)
        if bestTile?
            farm = new Farm(this,bestTile.x , bestTile.y)
            @farms.push(farm)
            @gold -= @farmPrice
            @farmPrice = @farmPrice * 2
        else
            @expandTown()

    expandTown: () ->
        console.log("ready to expand town")

        newBuildingTile = @findWorstFarmTile()

        if newBuildingTile?
            newBuilding = new Building(this, newBuildingTile.x, newBuildingTile.y)
            @buildings.push(newBuilding)


    calculateFood: () ->
        foodAmount = 5

        for farm in @farms
            farmValue = farm.value
            farmAmount = 100 * farm.value
            foodAmount += farmAmount

        return foodAmount







    findBestFarmTile: () ->

        maxTile = null

        #check up

        maxTile = @isBestTile(maxTile, @x, @y - 1)
        maxTile = @isBestTile(maxTile, @x - 1, @y )
        maxTile = @isBestTile(maxTile, @x + 1, @y )
        maxTile = @isBestTile(maxTile, @x , @y + 1 )


        for building in @buildings
            maxTile = @isBestTile(maxTile, building.x, building.y - 1)
            maxTile = @isBestTile(maxTile, building.x - 1, building.y )
            maxTile = @isBestTile(maxTile, building.x + 1, building.y )
            maxTile = @isBestTile(maxTile, building.x , building.y + 1 )

        return maxTile


    isBestTile: (bestTile, x,y) ->
        if bestTile?
            currentTile = @world.getTile(x,y)
            if @isFarmTileAvalaible(currentTile) == true
                if currentTile.value > bestTile.value
                    return currentTile
                else
                    return bestTile
            else
                return bestTile
        else
            currentTile = @world.getTile(x,y)
            if @isFarmTileAvalaible(currentTile)
                return currentTile
            else
                return null


    findWorstFarmTile: () ->

        maxTile = null

        #check up

        maxTile = @isWorstTile(maxTile, @x, @y - 1)
        maxTile = @isWorstTile(maxTile, @x - 1, @y )
        maxTile = @isWorstTile(maxTile, @x + 1, @y )
        maxTile = @isWorstTile(maxTile, @x , @y + 1 )


        for building in @buildings
            maxTile = @isWorstTile(maxTile, building.x, building.y - 1)
            maxTile = @isWorstTile(maxTile, building.x - 1, building.y )
            maxTile = @isWorstTile(maxTile, building.x + 1, building.y )
            maxTile = @isWorstTile(maxTile, building.x , building.y + 1 )

        return maxTile

    isWorstTile: (bestTile, x,y) ->
        if bestTile?
            currentTile = @world.getTile(x,y)
            if @isBuildingTileAvalaible(currentTile) == true
                if currentTile.value < bestTile.value
                    return currentTile
                else
                    return bestTile
            else
                return bestTile
        else
            currentTile = @world.getTile(x,y)
            if @isBuildingTileAvalaible(currentTile)
                return currentTile
            else
                return null


    isFarmTileAvalaible: (theTile) ->
        if theTile?
            if theTile.hasFarm == false && theTile.hasBuilding == false
                return true
            else
                return false
        else
            return false

    isBuildingTileAvalaible: (theTile) ->
        if theTile?
            if theTile.hasFarm == true && theTile.hasBuilding == false
                return true
            else
                return false
        else
            return false


