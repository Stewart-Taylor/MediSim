
class Agent

    constructor: (world, town, x, y, isGuard) ->
        @x = x
        @y = y

        @town = town

        @healthBar = new HealthBar(this)

        material = new (THREE.MeshLambertMaterial)(color: @town.color)
        @cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(1, 3, 1), material)
        @cube.position.y = 3
        @cube.position.x = x * 5
        @cube.position.z = y * 5
        @cube.castShadow = false
        @cube.receiveShadow = false
        @town.world.scene.add @cube

        @world = world
        @target = null

        @speed = 0.01
        @health = 1000
        @maxHealth = @health
        @strength = 1

        @active = true

        @isGuard = isGuard

        @homeGuardX = @x + (Math.floor(Math.random() * 2) + 1) - (Math.floor(Math.random() * 2) + 1)
        @homeGuardY = @y + (Math.floor(Math.random() * 2) + 1) - (Math.floor(Math.random() * 2) + 1)


    updateTarget: () ->
        closeTown = @getClosestTargetTown()
        closeUnit = @getClosestUnitTarget()
        if closeTown != null && closeUnit != null
            if closeTown.distance < closeUnit.distance
                @target = closeTown.target
                @targetX = @target.x
                @targetY = @target.y
            else
                @target = closeUnit.target
                @targetX = @target.x
                @targetY = @target.y
        else if closeTown == null && closeUnit != null
            @target = closeUnit.target
            @targetX = @target.x
            @targetY = @target.y
        else if closeTown != null && closeUnit == null
            @target = closeTown.target
            @targetX = @target.x
            @targetY = @target.y
        else
            return null

        #check for closest attackable object

    getClosestUnitTarget: () ->
        closeUnitTarget = null
        minUnitDistance = 100000
        for tempAgent in @world.agentManager.agents
            if tempAgent.active == true
                if @town.id != tempAgent.town.id
                    xDistance = Math.abs(@x - tempAgent.x)
                    yDistance = Math.abs(@y - tempAgent.y)
                    totalDistance = xDistance + yDistance
                    if totalDistance < minUnitDistance
                        minUnitDistance = totalDistance
                        closeUnitTarget = tempAgent

        if closeUnitTarget?
            targetObject = {}
            targetObject.target = closeUnitTarget
            targetObject.distance = minUnitDistance
            return targetObject
        else
            return null


    seekTarget: () ->
        closeUnitTarget = null
        minUnitDistance = 100000
        for tempAgent in @world.agentManager.agents
            if tempAgent.active == true
                if @town.id != tempAgent.town.id
                    xDistance = Math.abs(@x - tempAgent.x)
                    yDistance = Math.abs(@y - tempAgent.y)
                    totalDistance = xDistance + yDistance
                    if totalDistance < minUnitDistance
                        minUnitDistance = totalDistance
                        closeUnitTarget = tempAgent

        if closeUnitTarget?
            if minUnitDistance < 5
                return closeUnitTarget
            else
                return null
        else
            return null


    getClosestTargetTown: () ->
        closestTown = null
        minTownDistance = 10000
        for town in @world.towns
            if town.id != @town.id
                xDistance = Math.abs(@x - town.x)
                yDistance = Math.abs(@y - town.y)
                totalDistance = xDistance + yDistance
                if totalDistance < minTownDistance
                    minTownDistance = totalDistance
                    closestTown = town

        if closestTown?
            targetObject = {}
            targetObject.target = closestTown
            targetObject.distance = minTownDistance
            return targetObject
        else
            return null


    update: () ->
        @checkAgentsHealth()
        if @active == true
            @healthBar.update()

            if @target != null
                if @isGuard == false
                    @updateTarget()
                else
                    @target = @seekTarget()
                    if @target != null
                        @targetX = @target.x
                        @targetY = @target.y

            if @target != null
                @moveTowardsTarget()
            else
                if @isGuard
                    @moveToBase()

    moveToBase: () ->
        moveToCoordinates(@homeGuardX, @homeGuardY)


    checkAgentsHealth: () ->
        if @health <= 0
            @cube.position.y += 10
            @active = false
            #tell town to remove it


    isAtTarget: () ->
        xd2 = Math.abs(@targetX - @x)
        yd2 = Math.abs(@targetY - @y)

        if xd2 < 1 && yd2 < 1
            return true
        else
            return false


    attackTarget: () ->
        if(@target instanceof Town)
            if @target != @town.id
                @damage(1) #REMOVE later
                @target.damageTown(this, 1)
            else
                @target = null
        else if(@target instanceof Agent)
            if @target.active == true
                @target.damage(1)
                @cube.rotation.y += 0.2
            else
                @target = null
        else
            @cube.rotation.z += 1


    damage: (damageAmount) ->
        @health -= damageAmount
        if @health < 0
            @destroyAgent()


    destroyAgent: () ->
        @active = false
        healthBar.destroy()
        @town.removeAgent(this)
        @town.world.scene.remove @cube


    moveTowardsTarget: () ->
        if @isAtTarget()
            @attackTarget()
        else
            moveToCoordinates(@targetX, @targetY)


    moveToCoordinates: (xCoord, yCoord) ->
            xDistance = xCoord - @x
            yDistance = yCoord - @y

            hyp = Math.sqrt( (xDistance * xDistance) + (yDistance * yDistance))
            xDistance /= hyp
            yDistance /= hyp

            @x += xDistance * @speed
            @y += yDistance * @speed

            @cube.position.x = @x * 5
            @cube.position.z = @y * 5
