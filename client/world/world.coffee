

WORLD_HEIGHT = 40
WORLD_WIDTH = 50

TOWN_COUNT = 8

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


class World

    @towns = null

    constructor: (scene) ->

        @towns = []
        @tiles = []
        @agentManager = new AgentManager(this)

        @scene = scene
        x = 0
        y = 0


        worldGenerator = new WorldGenerator()
        grid = worldGenerator.generateWorld()


        for gridTile in grid
            # landValue = Math.random()
            # if landValue < 0.4
            #     landValue = 0.4
            newTile = new Tile(this, gridTile.x, gridTile.y, gridTile.value, gridTile.type)
            @tiles.push(newTile)

        @placeTowns()



    placeTowns: () ->

        vCount = 0
        townId = 1
        while vCount < TOWN_COUNT

            x = Math.floor((Math.random() * WORLD_WIDTH - 1) + 1)
            y = Math.floor((Math.random() * WORLD_HEIGHT - 1) + 1)

            townTile = @getTile(x, y)
            if townTile?
                if townTile.isLand
                    town = new Town(this,townId,TOWN_COLORS[vCount], x, y)
                    @towns.push(town)

                    vCount++
                    townId++


    update: () ->
        for town in @towns
            town.update()


    #TODO: A better way to getTile
    getTile: (x,y) ->
        if( x > 0) && ( x < WORLD_WIDTH)
            if ( y > 0 ) && ( y < WORLD_HEIGHT)
                for tempTile in @tiles

                    if tempTile.x == x && tempTile.y == y
                        return tempTile

        return null

