

WORLD_HEIGHT = 30
WORLD_WIDTH = 50

TOWN_COUNT = 8

class World

    @towns = null

    constructor: (scene) ->

        @towns = []
        @tiles = []

        @scene = scene
        x = 0
        y = 0

        while x < WORLD_WIDTH
            y= 0
            while y < WORLD_HEIGHT
                typeValue = Math.floor((Math.random() * 100) + 1);
                if typeValue < 2

                    type = 3
                else if ( typeValue > 4) && (typeValue < 8)
                    type = 2
                else
                    type = 1
                landValue = Math.random()
                if landValue < 0.4
                    landValue = 0.4
                newTile = new Tile(this, x, y, landValue, type)
                @tiles.push(newTile)
                y++
            x++



        vCount = 0
        townId = 1
        while vCount < TOWN_COUNT

            randX = Math.floor((Math.random() * WORLD_WIDTH - 2) + 1)
            randY = Math.floor((Math.random() * WORLD_HEIGHT - 2) + 1)

            town = new Town(this,townId, randX, randY)
            @towns.push(town)

            vCount++
            townId++


    update: () ->
        for town in @towns
            town.update()


    getTile: (x,y) ->
        if( x > 0) && ( x < WORLD_WIDTH)
            if ( y> 0 ) && ( y < WORLD_HEIGHT)
                for tempTile in @tiles

                    if tempTile.x == x && tempTile.y == y
                        return tempTile

        return null

