

TOWN_COLORS = [
    0xe74c3c # red
    0xe67e22 #orange
    0x6BB9F0 #blue
    0xDB0A5B #pink
    0xF2784B #peach
    0x90C695 #green
    0xBE90D4 #light purple
    0x8e44ad #dark purple
]

TOWN_COUNT = TOWN_COLORS.length


class World

    constructor: (scene) ->
        @scene = scene
        @towns = []
        @tiles = []
        @tilesPF = []
        worldGenerator = new WorldGenerator()

        @WORLD_WIDTH = worldGenerator.WORLD_WIDTH
        @WORLD_HEIGHT = worldGenerator.WORLD_HEIGHT


        @createWorld(worldGenerator)
        @agentManager = new AgentManager(scene, this)
        @placeTowns(worldGenerator)



    createWorld: (worldGenerator) ->
        grid = worldGenerator.generateWorld()
        @tiles = @createArray(worldGenerator.WORLD_WIDTH, worldGenerator.WORLD_HEIGHT)

        for gridTile in grid
            newTile = new Tile(this, gridTile.x, gridTile.y, gridTile.value, gridTile.type)
            @tiles[gridTile.x][gridTile.y] = newTile
            @tilesPF.push newTile
            # if newTile.isLand == true
            #     @landTiles.push newTile


    createArray: (length) ->
        arr = new Array(length or 0)
        i = length
        if arguments.length > 1
            args = Array::slice.call(arguments, 1)
            while i--
                arr[length - 1 - i] = @createArray.apply(this, args)
        return arr


    #TODO: Check if towns are placed too close together
    placeTowns: () ->
        placeCount = 0
        while placeCount < TOWN_COUNT

            x = Math.floor((Math.random() * @WORLD_WIDTH - 1) + 1)
            y = Math.floor((Math.random() * @WORLD_HEIGHT - 1) + 1)

            townTile = @getTile(x, y)
            if @canPlaceTown(townTile)
                town = new Town(this, placeCount + 1, TOWN_COLORS[placeCount], x, y)
                @towns.push(town)
                placeCount++

    canPlaceTown: (townTile) ->
        if townTile?
            if townTile.isLand

                invalidCount = 0
                if @isAdjacentTileLand(townTile.x - 1, townTile.y - 1) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x , townTile.y - 1) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x + 1, townTile.y - 1) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x - 1, townTile.y ) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x + 1, townTile.y ) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x - 1, townTile.y + 1) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x , townTile.y + 1) == false
                    invalidCount++
                if @isAdjacentTileLand(townTile.x + 1, townTile.y + 1) == false
                    invalidCount++

                if invalidCount == 0
                    for town in @towns
                        xDistance = Math.abs(townTile.x - town.x)
                        yDistance = Math.abs(townTile.y - town.y)

                        if ( xDistance + yDistance) < 8
                            return false
                    return true
        return false

    isAdjacentTileLand: (x, y) ->
        tile = @getTile(x,y)
        if tile?
            if tile.isLand
                return true
        return false



    update: () ->
        for town in @towns
            town.update()

        @agentManager.update()


    getTile: (x,y) ->
        if( x > 0) && ( x < @WORLD_WIDTH)
            if ( y > 0 ) && ( y < @WORLD_HEIGHT)
                return @tiles[x][y]
        return null

