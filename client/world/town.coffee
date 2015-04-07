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

        @technologyFactor = 0

        @agents = []

        @aggressiveness = Math.random()

        @farms = []
        @x = x
        @y = y

        @damageCounter = 100

        @agentsCount = 0

        material = new (THREE.MeshLambertMaterial)(color: @color)
        @cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(5, 10, 5), material)
        @cube.position.y = 1
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.rotation.y = Math.random() * (10 - 1) + 1
        @cube.castShadow = true
        @cube.receiveShadow = true
        world.scene.add @cube

        @expandBorders(@x, @y)
        @lastremoveCounter = 100

        @expandCount = 5


    update: () ->
        @food += @calculateFood()
        @foodDif = @food - @population - (@agentsCount * 100)

        #Check to see if there is enough food
        if @foodDif < 0
            @population += @foodDif
            if @population < 10
                @population = 10
            @food = 0

            if @lastremoveCounter <= 0
                @removeWorstBuilding()
                @lastremoveCounter = 100
            @lastremoveCounter--

        else
            @food = @food - @population
            @increasePopulation()

            if @food > @population * 4
                @food = @population * 4

        @population = Math.round(@population)


        if @gold > @farmPrice
            @buyFarm()

        # if @technologyFactor < 1
        #     @technologyFactor +=  (@population / 10000000)
        # else if @technologyFactor < 2
        #     @technologyFactor +=  (@population / 100000000000)
        # else
        #     @technologyFactor = 2

        @calculateUnitPoints()




    increasePopulation: () ->
        if @population < @getMaxPopulation()
            @population += 1 + @technologyFactor
        else
            @population = @getMaxPopulation()


    getMaxPopulation: () ->
        buildingCount = 0
        for building in @buildings
            if building.active == true
                buildingCount++

        maxPopulation = (buildingCount * 100)
        maxPopulation += 100
        return maxPopulation


    #Removes the builing on the best farm land
    removeWorstBuilding:() ->
        maxBuilding
        maxValue = 0
        for building in @buildings
            if building.active
                if building.myTile.value > maxValue
                    maxValue = building.myTile.value
                    maxBuilding = building

        if maxBuilding?
            maxBuilding.destroy()
            #TODO: destroy buildings



    buyFarm: () ->
        bestTile = @findBestFarmTile()

        if bestTile?
            farm = new Farm(this, bestTile.x, bestTile.y)
            @farms.push(farm)
            @gold -= @farmPrice
            # @farmPrice = @farmPrice + 200
            @expandBorders(bestTile.x, bestTile.y)
        else
            @expandTown()

    expandTown: () ->
        if @population >= @getMaxPopulation()

            newBuildingTile = @findWorstFarmTile()

            if newBuildingTile?
                newBuilding = new Building(this, @color, newBuildingTile.x, newBuildingTile.y)
                @buildings.push(newBuilding)
                @expandBorders(newBuildingTile.x, newBuildingTile.y)
                # @degradeFarmTiles(newBuildingTile.x, newBuilding.y)

                for farm in @farms
                    if (farm.x == newBuilding.x) && (farm.y == newBuilding.y)
                        farm.active = false
                        #TODO:destroy farm complete
        #else
            # buy trader?



    calculateFood: () ->
        foodAmount = 5

        workingPopulation = @population

        for farm in @farms
            farm.check()
            if workingPopulation > 0
                if farm.active == true
                    farmValue = farm.value
                    farmAmount = (100 * ( @technologyFactor + 1) )* farm.value
                    foodAmount += farmAmount
                    workingPopulation -= 10

        @gold += 1
        if workingPopulation > 0
            @gold += Math.round(workingPopulation / 100)

        return foodAmount


    #TODO: check and see if this refactor works
    damageTown: (attackingAgent, damageAmount) ->
        @population -= damageAmount

        @damageCounter--
        if @damageCounter < 0
            @removeWorstBuilding()
            @damageCounter = 100

        if @population < 0
            @population = 0
            @id = attackingAgent.town.id
            @color = attackingAgent.town.color
            @cube.material = attackingAgent.town.cube.material
            @population = 0
            @food = 0
            @gold = 0

            for building in @buildings
                building.cube.material = attackingAgent.town.cube.material

            for agent in @agents
                agent.damage(9999999)

    calculateUnitPoints: () ->
        if @gold > @getUnitCost()
            @buyAgent()


    getUnitCost: () ->
        cost = 10000
        # cost += cost * @getAgentCount()
        return cost


    buyAgent: () ->
        @gold -= @getUnitCost()
        # if targetTown?

        rValue =  Math.random()
        if rValue > @aggressiveness
            agent = @world.agentManager.addAgent(@world, this, @x, @y, true)
        else
            agent = @world.agentManager.addAgent(@world, this, @x, @y, false)

        @agents.push agent
        @unitPoints -= 1000
        # else #converts gold to food
        #     @food += @gold / 2
        #     @gold = @gold / 2


    getAgentCount: () ->
        aCount = 0
        for agent in @agents
            if agent.active == true
                aCount++

        return aCount


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
        currentTile = @world.getTile(x,y)
        if bestTile?
            if @isFarmTileAvalaible(currentTile) == true
                if currentTile.value > bestTile.value
                    return currentTile
                else
                    return bestTile
            else
                return bestTile
        else
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
        # distance = @distanceToTown(theTile.x, theTile.y)
        # buildingValue = value * (distance *2)
        return value

    findWorstFarmTile: () ->

        maxTile = null

        maxTile = @isWorstTile(maxTile, @x, @y - 1) #up
        maxTile = @isWorstTile(maxTile, @x - 1, @y - 1) #up left
        maxTile = @isWorstTile(maxTile, @x + 1, @y - 1) #up right
        maxTile = @isWorstTile(maxTile, @x - 1, @y )# left
        maxTile = @isWorstTile(maxTile, @x + 1, @y )#right
        maxTile = @isWorstTile(maxTile, @x , @y + 1 )#down
        maxTile = @isWorstTile(maxTile, @x - 1, @y + 1 )#down left
        maxTile = @isWorstTile(maxTile, @x + 1, @y + 1 )#down right

        for farm in @farms
            maxTile = @isWorstTile(maxTile, farm.x, farm.y - 1) #up
            maxTile = @isWorstTile(maxTile, farm.x + 1, farm.y - 1) #up right
            maxTile = @isWorstTile(maxTile, farm.x - 1, farm.y - 1) #up left
            maxTile = @isWorstTile(maxTile, farm.x - 1, farm.y )#left
            maxTile = @isWorstTile(maxTile, farm.x + 1, farm.y )#right
            maxTile = @isWorstTile(maxTile, farm.x , farm.y + 1 )#down
            maxTile = @isWorstTile(maxTile, farm.x + 1 , farm.y + 1 )#down right
            maxTile = @isWorstTile(maxTile, farm.x  - 1, farm.y + 1 )#down left

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
            if @isOwner(theTile) == true
                if theTile.isLand && theTile.hasFarm == false && theTile.hasBuilding == false
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



