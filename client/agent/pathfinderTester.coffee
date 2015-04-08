

WORLD_HEIGHT = 30
WORLD_WIDTH = 50


grid = []

y = 0
while y < WORLD_HEIGHT
    x = 0
    while x < WORLD_WIDTH
        tile = {}
        tile.x = x
        tile.y = y
        rv = Math.random()
        if rv < 0.1
            tile.isLand = false
        else
            tile.isLand = true
        grid.push(tile)
        x++
    y++


pathFinder = new PathFinder()


getTile =  (x,y) ->
    for tile in grid
        if (tile.x == x) && (tile.y == y)
            return tile
    return null


printGrid = () ->

    console.log("World Generated")
    console.log()
    y = 0
    while y < WORLD_HEIGHT
        lineString = ""
        x = 0
        while x < WORLD_WIDTH
            temp = getTile(x,y)
            if  temp.isLand
                lineString += "."
            else
                lineString += "#"
            # lineString += (Math.round( gen.getTile(x,y).value * 10 )) + "|"
            x++
        console.log(lineString)
        y++
    console.log()
    console.log()



printGrid()
