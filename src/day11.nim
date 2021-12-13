import sequtils, strutils, sugar
let sample = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

proc propogateFlash(grid: var seq[seq[int]], i, j: int) =
    let maxX = grid.len() - 1
    let maxY = grid[0].len() - 1
    if i > 0 and j > 0: grid[i-1][j-1] += 1
    if i > 0: grid[i-1][j] += 1
    if i > 0 and j < maxY: grid[i-1][j+1] += 1

    if j > 0: grid[i][j-1] += 1
    if j < maxY: grid[i][j+1] += 1

    if i < maxX and j > 0: grid[i+1][j-1] += 1
    if i < maxX: grid[i+1][j] += 1
    if i < maxX and j < maxY: grid[i+1][j+1] += 1

proc incrementFlash(grid: var seq[seq[int]]) =
    for i in countup(0, grid.len - 1):
        for j in countup(0, grid[i].len - 1):
            grid[i][j]+=1

proc clearFlash(grid: var seq[seq[int]]) = 
    for i in countup(0, grid.len - 1):
        for j in countup(0, grid[i].len - 1):
            if grid[i][j] < 0: grid[i][j] = 0

# returns flashes
proc stepFlash(grid: var seq[seq[int]]) : int = 
    for i in countup(0, grid.len - 1):
        for j in countup(0, grid[i].len - 1):
            if grid[i][j] > 9:
                grid[i][j]=int.low
                result += 1
                propogateFlash(grid, i, j)

proc step(grid: var seq[seq[int]]) : int = 
    incrementFlash(grid)
    while true:
        let newFlashes = stepFlash(grid)
        result += newFlashes
        if newFlashes == 0: break
    clearFlash(grid)


proc solve_a(input: string): int = 
    var grid = input.strip.splitLines.mapIt(it.strip.toSeq.map(x => int(x) - int('0')))
    for i in countup(0, 100-1):
        result += step(grid)
        #echo grid
    
proc solve_b(input: string): int = 
    var grid = input.strip.splitLines.mapIt(it.strip.toSeq.map(x => int(x) - int('0')))
    var i = 0
    let expectedFlashes = grid.len * grid[0].len
    while true:
        i += 1
        let flashes = step(grid)
        if flashes == expectedFlashes:
            return i

        #echo grid

let input = """
6636827465
6774248431
4227386366
7447452613
6223122545
2814388766
6615551144
4836235836
5334783256
4128344843
"""

echo solve_a(sample)
echo solve_b(sample)
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)
