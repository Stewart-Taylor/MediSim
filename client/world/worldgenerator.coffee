
class WorldGenerator

    WORLD_WIDTH = 60
    WORLD_HEIGHT = 30
    COAST_ERODE_PASSES = 5
    MOUNTAIN_PASSES = 7
    TREE_PASSES = 7

    LAND_TILE = 1
    LAND_TILE_CHAR = "#"

    WATER_TILE = 2
    WATER_TILE_CHAR = "."

    MOUNTAIN_TILE = 3
    MOUNTAIN_TILE_CHAR = "^"

    TREE_TILE = 4
    TREE_TILE_CHAR = "|"

    LAKE_TILE = 5
    LAKE_TILE_CHAR = "."


    constructor: () ->
        @WORLD_WIDTH = 60
        @WORLD_HEIGHT = 30
        @map = []
        @mpass_value = 0.5


    generateWorld: () ->
        timestart = Date.now()
        @createBaseLand()
        @createWaterEdges()
        @coastErode()
        @addMountains()
        @addLakes()
        @addTrees()
        @generateYield()
        @convertLakeToWater() #REMOVE later
        @time_taken = Date.now() - timestart

        return @map


    #Remove and turn into lake at later point
    convertLakeToWater: () ->
        for tile in @map
            if tile.type == LAKE_TILE
                tile.type = WATER_TILE


    addLakes: () ->
        mountainTiles = []
        mountainPlaces = 7

        while mountainPlaces > 0
            rX = Math.floor(Math.random() * WORLD_WIDTH) + 1
            rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1

            tile = @getTile(rX, rY)
            if tile?
                if tile.type == LAND_TILE
                    tile.type = LAKE_TILE
                    mountainTiles. push tile
                    mountainPlaces--

        passes = Math.floor(Math.random() * TREE_PASSES) + 3
        while passes > 0
            @lakePass()
            @mpass_value -= 0.1
            if mpass_value < 0.1
                mpass_value = 0.1
            passes--


    lakePass: () ->
        mountainTiles = []
        for tile in @map
            if tile.type == LAKE_TILE
                mountainTiles.push tile

        for mountainTile in mountainTiles
            @convertLakeTile(mountainTile.x, mountainTile.y - 1)
            @convertLakeTile(mountainTile.x + 1, mountainTile.y)
            @convertLakeTile(mountainTile.x - 1, mountainTile.y)
            @convertLakeTile(mountainTile.x, mountainTile.y + 1)

    convertLakeTile: (x, y) ->
        tile = @getTile(x,y)
        if tile?
            rValue = Math.random()
            if rValue < 0.5
                if tile.type == LAND_TILE
                    tile.type = LAKE_TILE

    addTrees: () ->
        mountainTiles = []
        mountainPlaces = 7

        while mountainPlaces > 0
            rX = Math.floor(Math.random() * WORLD_WIDTH) + 1
            rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1

            tile = @getTile(rX, rY)
            if tile?
                if tile.type == LAND_TILE
                    tile.type = TREE_TILE
                    mountainTiles. push tile
                    mountainPlaces--

        passes = Math.floor(Math.random() * TREE_PASSES) + 3
        while passes > 0
            @treePass()
            @mpass_value -= 0.1
            if mpass_value < 0.1
                mpass_value = 0.1
            passes--


    treePass: () ->
        mountainTiles = []
        for tile in @map
            if tile.type == TREE_TILE
                mountainTiles.push tile

        for mountainTile in mountainTiles
            @convertTreeTile(mountainTile.x, mountainTile.y - 1)
            @convertTreeTile(mountainTile.x + 1, mountainTile.y)
            @convertTreeTile(mountainTile.x - 1, mountainTile.y)
            @convertTreeTile(mountainTile.x, mountainTile.y + 1)

    convertTreeTile: (x, y) ->
        tile = @getTile(x,y)
        if tile?
            rValue = Math.random()
            if rValue < 0.5
                if tile.type == LAND_TILE
                    tile.type = TREE_TILE


    generateYield: () ->

        for tile in @map
            if tile.type == LAND_TILE
                rValue = Math.random()
                if rValue < 0.2 #Min Cap
                    rValue = 0.2
                tile.value = rValue
            else
                tile.value = 0

        passes = 1
        while passes > 0
            @smoothYield()
            passes--

    #TODO: Account for land tiles in tileCount
    smoothYield: () ->
        for tile in @map
            total = 0
            tileCount = 9

            total += @adjacentTileLandValue(tile.x - 1, tile.y - 1)
            total += @adjacentTileLandValue(tile.x, tile.y - 1)
            total += @adjacentTileLandValue(tile.x + 1, tile.y - 1)
            total += @adjacentTileLandValue(tile.x - 1 , tile.y)
            total += @adjacentTileLandValue(tile.x + 1 , tile.y)
            total += @adjacentTileLandValue(tile.x - 1, tile.y + 1)
            total += @adjacentTileLandValue(tile.x, tile.y  + 1)
            total += @adjacentTileLandValue(tile.x + 1, tile.y + 1)

            avg = total / tileCount

            if avg < 0.2
                avg = 0.2
            tile.value = avg


    adjacentTileLandValue: (x,y) ->
        tile = @getTile(x,y)
        if tile?
            if tile.type == LAND_TILE
                return tile.value
        return 0


    addMountains: () ->

        mountainTiles = []
        mountainPlaces = 4

        while mountainPlaces > 0
            rX = Math.floor(Math.random() * WORLD_WIDTH) + 1
            rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1

            tile = @getTile(rX, rY)
            if tile?
                if tile.type == LAND_TILE
                    tile.type = MOUNTAIN_TILE
                    mountainTiles. push tile
                    mountainPlaces--

        passes = Math.floor(Math.random() * MOUNTAIN_PASSES) + 3
        while passes > 0
            @mountainPass()
            @mpass_value -= 0.1
            if mpass_value < 0.1
                mpass_value = 0.1
            passes--



    mountainPass: () ->

        mountainTiles = []
        for tile in @map
            if tile.type == MOUNTAIN_TILE
                mountainTiles.push tile

        for mountainTile in mountainTiles
            @convertMountainTile(mountainTile.x, mountainTile.y - 1)
            @convertMountainTile(mountainTile.x + 1, mountainTile.y)
            @convertMountainTile(mountainTile.x - 1, mountainTile.y)
            @convertMountainTile(mountainTile.x, mountainTile.y + 1)


    convertMountainTile: (x, y) ->
        tile = @getTile(x,y)
        if tile?
            rValue = Math.random()
            if rValue < @mpass_value
                if tile.type == LAND_TILE
                    tile.type = MOUNTAIN_TILE


    #Creates the base land map
    createBaseLand: () ->
        y = 0
        while y < WORLD_HEIGHT
            x = 0
            while x < WORLD_WIDTH
                tile = {}
                tile.x = x
                tile.y = y
                tile.type = LAND_TILE
                @map.push(tile)
                x++
            y++


    #converts all edges into water
    createWaterEdges: () ->

        x = 0
        while x < WORLD_WIDTH
            tile1 = @getTile(x, 0)
            tile2 = @getTile(x, WORLD_HEIGHT - 1)
            if tile1?
                tile1.type = WATER_TILE
            if tile2?
                tile2.type = WATER_TILE
            x++

        y = 0
        while y < WORLD_HEIGHT
            tile1 = @getTile(0, y)
            tile2 = @getTile(WORLD_WIDTH - 1, y)
            if tile1?
                tile1.type = WATER_TILE
            if tile2?
                tile2.type = WATER_TILE
            y++


    coastErode: () ->
        waterPasses = COAST_ERODE_PASSES
        while waterPasses > 0
            @waterAdjactent()
            waterPasses--


    waterAdjactent: () ->
        waterTiles = []

        for tile in @map
            if tile.type == WATER_TILE
                waterTiles.push tile

        for waterTile in waterTiles
            @waterTileConvert(waterTile.x, waterTile.y - 1)
            @waterTileConvert(waterTile.x + 1, waterTile.y)
            @waterTileConvert(waterTile.x - 1, waterTile.y)
            @waterTileConvert(waterTile.x, waterTile.y + 1)


    waterTileConvert: (x,y) ->
        tile = @getTile(x,y)
        if tile?
            rValue = Math.random()
            if rValue < 0.5
                tile.type = WATER_TILE


    getTile: (x,y) ->
        for tile in @map
            if (tile.x == x) && (tile.y == y)
                return tile
        return null


    printMapToConsole: () ->
        console.log("World Generated")
        console.log()
        y = 0
        while y < WORLD_HEIGHT
            lineString = ""
            x = 0
            while x < WORLD_WIDTH
                lineString += @getTileChar(gen.getTile(x,y).type)
                # lineString += (Math.round( gen.getTile(x,y).value * 10 )) + "|"
                x++
            console.log(lineString)
            y++
        console.log()
        console.log("" + @time_taken + "ms" )
        console.log()

    getTileChar: (type) ->
        if type == LAND_TILE
            return LAND_TILE_CHAR
        else if type == WATER_TILE
            return WATER_TILE_CHAR
        else if type == MOUNTAIN_TILE
            return MOUNTAIN_TILE_CHAR
        else if type == TREE_TILE
            return TREE_TILE_CHAR


gen = new WorldGenerator()
gen.generateWorld()
gen.printMapToConsole()
