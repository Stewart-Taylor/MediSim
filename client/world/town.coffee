class Town


    constructor: (world, id, color, x,y) ->

        @id = id
        @world = world
        @color = color
        @population = 10
        @food = 100
        @gold = 70
        @farmPrice = 100
        @buildings = []
        @newBuildingCost = 1000
        @unitPoints = 0

        @farms = []
        @x = x
        @y = y

        @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(5, 10, 5), new (THREE.MeshLambertMaterial)(color: @color))
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = true
        @cube.receiveShadow = true
        world.scene.add @cube

        @expandBorders(@x, @y)


    update: () ->
        @food += @calculateFood()
        foodDif = @food - @population

        if foodDif < 0
            @population += foodDif
            @food = 0
        else
            @food = @food - @population
            @population += @population + 1




        @gold = @gold + @population / 2

        if @gold > @farmPrice
            @buyFarm()

        @calculateUnitPoints()

    buyFarm: () ->

        bestTile = @findBestFarmTile()


        console.log(bestTile)
        if bestTile?
            farm = new Farm(this,bestTile.x , bestTile.y)
            @farms.push(farm)
            @gold -= @farmPrice
            @farmPrice = @farmPrice * 1.5
            @expandBorders(bestTile.x, bestTile.y)
        else
            @expandTown()

    expandTown: () ->
        console.log("ready to expand town")

        newBuildingTile = @findWorstFarmTile()

        if newBuildingTile?
            newBuilding = new Building(this, @color, newBuildingTile.x, newBuildingTile.y)
            @buildings.push(newBuilding)
            @consumeRate += 0.1
            @expandBorders(newBuildingTile.x, newBuildingTile.y)

            @degradeFarmTiles(newBuildingTile.x, newBuilding.y)

            for farm in @farms
                if (farm.x == newBuilding.x) && (farm.y == newBuilding.y)
                    farm.active = false



    calculateFood: () ->
        foodAmount = 5

        for farm in @farms
            if farm.active == true
                farmValue = farm.value
                farmAmount = 100 * farm.value
                foodAmount += farmAmount

        return foodAmount


    calculateUnitPoints: () ->
        @unitPoints += @buildings.length

        if @unitPoints > 1000
            console.log("can buy unit")
            buyAgent()

    buyAgent: () ->
        world.agentManager.addAgent(this, @x, @y)
        @unitPoints -= 1000


    degradeFarmTiles: (x, y) ->
        @degradeFarmTile(@x, @y - 1)
        @degradeFarmTile(@x - 1, @y )
        @degradeFarmTile(@x + 1, @y )
        @degradeFarmTile(@x , @y + 1 )


    degradeFarmTile: (x,y) ->
        currentTile = @world.getTile(x,y)
        currentTile.value -= 0.1
        if currentTile.value < 0.01
            currentTile.value = 0.01

        if currentTile.hasFarm
            for farm in @farms
                if (x == farm.x)  && ( y == farm.y)
                    farm.value = currentTile.value


    findBestFarmTile: () ->

        maxTile = null

        #check up

        maxTile = @isBestTile(maxTile, @x, @y - 1)
        maxTile = @isBestTile(maxTile, @x - 1, @y - 1)
        maxTile = @isBestTile(maxTile, @x + 1, @y - 1)
        maxTile = @isBestTile(maxTile, @x - 1, @y )
        maxTile = @isBestTile(maxTile, @x + 1, @y )
        maxTile = @isBestTile(maxTile, @x , @y + 1 )
        maxTile = @isBestTile(maxTile, @x + 1, @y + 1 )
        maxTile = @isBestTile(maxTile, @x - 1, @y + 1 )


        for building in @buildings
            maxTile = @isBestTile(maxTile, building.x, building.y - 1)
            maxTile = @isBestTile(maxTile, building.x + 1, building.y - 1)
            maxTile = @isBestTile(maxTile, building.x - 1, building.y - 1)
            maxTile = @isBestTile(maxTile, building.x - 1, building.y )
            maxTile = @isBestTile(maxTile, building.x + 1, building.y )
            maxTile = @isBestTile(maxTile, building.x , building.y + 1 )
            maxTile = @isBestTile(maxTile, building.x + 1, building.y + 1 )
            maxTile = @isBestTile(maxTile, building.x - 1, building.y + 1 )

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



    distanceToTown: (x,y) ->
        distanceX = Math.abs(@x - x)
        distanceY = Math.abs(@y - y)
        distance = distanceX + distanceY
        return distance


    buildingTileValue: (theTile) ->
        value = theTile.value
        distance = @distanceToTown(theTile.x, theTile.y)

        buildingValue = value * (distance *2)

        return buildingValue

    findWorstFarmTile: () ->

        maxTile = null

        #check up

        maxTile = @isWorstTile(maxTile, @x, @y - 1) #up
        # maxTile = @isWorstTile(maxTile, @x - 1, @y - 1) #up left
        # maxTile = @isWorstTile(maxTile, @x + 1, @y - 1) #up right
        maxTile = @isWorstTile(maxTile, @x - 1, @y )# left
        maxTile = @isWorstTile(maxTile, @x + 1, @y )#right
        maxTile = @isWorstTile(maxTile, @x , @y + 1 )#down
        # maxTile = @isWorstTile(maxTile, @x - 1, @y + 1 )#down left
        # maxTile = @isWorstTile(maxTile, @x + 1, @y + 1 )#down right


        for building in @buildings
            maxTile = @isWorstTile(maxTile, building.x, building.y - 1) #up
            # maxTile = @isWorstTile(maxTile, building.x + 1, building.y - 1) #up right
            # maxTile = @isWorstTile(maxTile, building.x - 1, building.y - 1) #up left
            maxTile = @isWorstTile(maxTile, building.x - 1, building.y )#left
            maxTile = @isWorstTile(maxTile, building.x + 1, building.y )#right
            maxTile = @isWorstTile(maxTile, building.x , building.y + 1 )#down
            # maxTile = @isWorstTile(maxTile, building.x + 1 , building.y + 1 )#down right
            # maxTile = @isWorstTile(maxTile, building.x  - 1, building.y + 1 )#down left

        return maxTile

    isWorstTile: (bestTile, x,y) ->
        if bestTile?
            currentTile = @world.getTile(x,y)
            if @isBuildingTileAvalaible(currentTile) == true
                if @buildingTileValue(currentTile) < @buildingTileValue(bestTile)
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
            if theTile.hasFarm == false && theTile.hasBuilding == false && theTile.isLand && @isOwner(theTile) == true
                if @hasOtherBorder(theTile.x, theTile.y) == false
                    return true
        return false


    isOwner: (theTile) ->
        if theTile.hasOwner == false
            return false
        else
            if theTile.owner.id == @id
                return true


    hasOtherBorder: (x,y) ->
        count = 0
        count += @isOtherBorder(x - 1, y - 1)
        count += @isOtherBorder(x , y - 1)
        count += @isOtherBorder(x + 1, y - 1)
        count += @isOtherBorder(x - 1, y )
        count += @isOtherBorder(x + 1, y )
        count += @isOtherBorder(x - 1, y + 1)
        count += @isOtherBorder(x , y + 1)
        count += @isOtherBorder(x + 1, y + 1)

        if count > 0
            return true
        else
            return false


    isOtherBorder: (x,y) ->
        otherTile = @world.getTile(x,y)
        if otherTile?
            if otherTile.hasOwner == true
                if otherTile.owner.id == @id
                    return 0
                else
                    return 1
            else
                return 0
        else
            return 0




    isBuildingTileAvalaible: (theTile) ->
        if theTile?
            if theTile.hasFarm == true && theTile.hasBuilding == false && @isOwner(theTile) == true
                return true
            else
                return false
        else
            return false


    expandBorders: (x,y) ->
        @claimTile(x - 1, y - 1)
        @claimTile(x , y - 1)
        @claimTile(x + 1, y - 1)
        @claimTile(x - 1, y )
        @claimTile(x + 1, y )
        @claimTile(x - 1, y + 1)
        @claimTile(x , y + 1)
        @claimTile(x + 1, y + 1)


    claimTile: (x,y) ->
        claimTile = @world.getTile(x,y)
        if claimTile?
            if claimTile.hasOwner == false
                if @hasOtherBorder(x,y ) == false
                    claimTile.hasOwner = true
                    claimTile.owner = this

                    # claimMaterial = new (THREE.MeshLambertMaterial)(color: 0x3498db)
                    # claimMaterial.transparent = true
                    # claimMaterial.opacity = 0.3
                    # @cube = new (THREE.Mesh)(new (THREE.CubeGeometry)(1, 6, 1), claimMaterial)
                    # @cube.position.y = 1
                    # @cube.position.x = x * 5
                    # @cube.position.z = y * 5
                    # @cube.castShadow = false
                    # @cube.receiveShadow = false
                    # @world.scene.add @cube



