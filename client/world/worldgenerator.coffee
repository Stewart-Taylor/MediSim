
WORLD_WIDTH = 50
WORLD_HEIGHT = 20
COAST_ERODE_PASSES = 5

class WorldGenerator

    LAND_TILE = "#"
    WATER_TILE = "."


    constructor: () ->
        @map = []


    generateWorld: () ->

        @createBaseLand()
        @createWaterEdges()
        @coastErode()

        return @map


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
                lineString += gen.getTile(x,y).type
                x++
            console.log(lineString)
            y++
        console.log()


gen = new WorldGenerator()


gen.generateWorld()
gen.printMapToConsole()
