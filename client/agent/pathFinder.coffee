class PathFinder


    constructor: (width, height, map) ->

        @width = width
        @height = height
        @grid = @createArray(width, height)

        for mapTile in map
            gridTile = {}
            gridTile.x = mapTile.x
            gridTile.y = mapTile.y
            gridTile.f = 0
            gridTile.g = 0
            gridTile.h = 0
            gridTile.debug = ""
            if mapTile.isLand == true
                gridTile.isWall = false
            else
                gridTile.isWall = true

            @grid[gridTile.x][gridTile.y] = gridTile


    createArray: (length) ->
        arr = new Array(length or 0)
        i = length
        if arguments.length > 1
            args = Array::slice.call(arguments, 1)
            while i--
                arr[length - 1 - i] = @createArray.apply(this, args)
        return arr



    findPath: (start, end)->

        #start {} pos:x, pos:y
        #end {}, pos:x, pos:y

        # console.log(@grid)

        openList   = []
        closedList = []
        openList.push(start)

        while(openList.length > 0)

            # console.log(openList)

            # Grab the lowest f(x) to process next
            lowInd = 0


            i = 0
            while i < openList.length
                if openList[i].f < openList[lowInd].f
                    lowInd = i
                i++

            currentNode = openList[lowInd]


            # End case -- result has been found, return the traced path
            if currentNode.x == end.x && currentNode.y == end.y
                curr = currentNode
                ret = []
                while(curr.parent)
                    ret.push(curr)
                    curr = curr.parent
                return ret.reverse()


            #Normal case -- move currentNode from open to closed, process each of its neighbors
            @removeGraphNode(openList, currentNode)
            closedList.push(currentNode)
            neighbors = @neighbors(@grid, currentNode) # method for getting neighbours

            # console.log("Neighbors len: " + neighbors.length)
            x = 0
            while x < neighbors.length


                # console.log("x: "  + x)

                neighbor = neighbors[x]

                x++
                if (@hasGraphNode(closedList, neighbor)) || neighbor.isWall == true
                    # not a valid node to process, skip to next neighbor
                    continue




                # g score is the shortest distance from start to current node, we need to check if
                #   the path we have arrived at this neighbor is the shortest one we have seen yet
                gScore = currentNode.g + 1  # 1 is the distance from a node to it's neighbor
                gScoreIsBest = false


                if(!@hasGraphNode(openList, neighbor))
                    # This the the first time we have arrived at this node, it must be the best
                    # Also, we need to take the h (heuristic) score since we haven't done so yet

                    gScoreIsBest = true
                    neighbor.h = @heuristic(neighbor, end)
                    openList.push(neighbor)

                else if(gScore < neighbor.g)
                    # We have already seen the node, but last time it had a worse g (distance from start)
                    gScoreIsBest = true


                if(gScoreIsBest)
                    # Found an optimal (so far) path to this node.  Store info on how we got here and
                    #  just how good it really is...
                    neighbor.parent = currentNode
                    neighbor.g = gScore
                    neighbor.f = neighbor.g + neighbor.h
                    #neighbor.debug = "F: " + neighbor.f + "<br />G: " + neighbor.g + "<br />H: " + neighbor.h;

                # x++

        # No result was found -- empty array signifies failure to find path
        return []



    removeGraphNode: (list, node) ->
        index = list.indexOf(node)
        list.splice(index, 1)

    hasGraphNode: (list, node) ->
        if list.indexOf(node) > -1
            return true
        else
            return false


    heuristic: (pos1, pos2) ->
        # This is the Manhattan distance

        return dist = Math.sqrt( Math.pow((pos1.x - pos2.x), 2) + Math.pow((pos1.y - pos2.y), 2) )

        # distanceX = Math.abs (pos1.x - pos2.x)
        # distanceY = Math.abs (pos1.y - pos2.y)
        # return distanceX + distanceY


    neighbors: (grid, node) ->
        ret = []
        x = node.x
        y = node.y


        item = @addTile(x - 1, y - 1)
        if item?
            ret.push item

        item = @addTile(x , y - 1)
        if item?
            ret.push item

        item = @addTile(x + 1, y - 1)
        if item?
            ret.push item

        item = @addTile(x - 1, y)
        if item?
            ret.push item


        item = @addTile(x + 1, y)
        if item?
            ret.push item

        item = @addTile(x - 1, y + 1)
        if item?
            ret.push item

        item = @addTile(x , y + 1)
        if item?
            ret.push item

        item = @addTile(x + 1, y + 1)
        if item?
            ret.push item


        # if x > 1
        #     if(grid[x - 1][y] && grid[ x - 1][y])
        #         ret.push(grid[x - 1][y])

        #     if(grid[x - 1][y] && grid[ x - 1][y - 1])
        #         ret.push(grid[x - 1][y - 1])

        # if x < @width - 1
        #     if(grid[x + 1][y] && grid[x + 1][y])
        #         ret.push(grid[x + 1][y])

        #     if(grid[x + 1][y] && grid[x + 1][y + 1])
        #         ret.push(grid[x + 1][y + 1])

        # if y > 1
        #     if(grid[x][y - 1] && grid[x][y - 1])
        #         ret.push(grid[x][y - 1])

        # if y < @height - 1
        #     if(grid[x][y + 1] && grid[x][y + 1])
        #         ret.push(grid[x][y + 1])

        return ret


    addTile: (x, y) ->
        console.log(x + "," + y)
        tTile = @grid[Math.round(x)][Math.round(y)]
        if tTile?
            return tTile
        else
            return null









class PathFinderTester


    constructor: (PathFinder) ->

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
                if rv < 0.2
                    tile.isLand = false
                else
                    tile.isLand = true
                grid.push(tile)
                x++
            y++

        pathFinder = new PathFinder(WORLD_WIDTH, WORLD_HEIGHT, grid)

        start = {}
        start.x = 1
        start.y = 1
        target = {}
        target.x = 20
        target.y = 20
        path = pathFinder.findPath(start, target)


        getTile =  (x,y) ->
            for tile in grid
                if (tile.x == x) && (tile.y == y)
                    return tile
            return null


        isPath =  (paths, x,y) ->
            for pathT in paths
                if (pathT.x == x) && (pathT.y == y)
                    return true
            return false


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

        printPath = (path) ->
            console.log("Path Generated")
            console.log()
            y = 0
            while y < WORLD_HEIGHT
                lineString = ""
                x = 0
                while x < WORLD_WIDTH
                    if  isPath(path, x, y)
                        lineString += "."
                    else
                        lineString += "#"
                    # lineString += (Math.round( gen.getTile(x,y).value * 10 )) + "|"
                    x++
                console.log(lineString)
                y++
            console.log()
            console.log()

        printPathGrid = (path) ->
            console.log("Generated")
            console.log()
            y = 0
            while y < WORLD_HEIGHT
                lineString = ""
                x = 0
                while x < WORLD_WIDTH
                    temp = getTile(x,y)
                    if  temp.isLand
                        if  isPath(path, x, y)
                            lineString += "o"
                        else
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
        printPath(path)
        printPathGrid(path)




# tester = new PathFinderTester(PathFinder)



