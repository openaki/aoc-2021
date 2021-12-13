import strutils, sequtils, sets

proc populatePaper(input: string): (HashSet[(int, int)], seq[string])=
    var grid = initHashSet[(int, int)]()
    var populateGrid = true
    var folds  = newSeq[string]()
    for ln in input.strip.splitLines:
        if ln.strip.len == 0: 
            populateGrid = false
            continue

        if populateGrid:
            let coord = ln.strip.split(",").mapIt(it.parseInt)
            grid.incl((coord[0], coord[1]))
            continue

        folds.add(ln.strip.splitWhitespace()[2]) 

    return (grid, folds) 

proc handleFold(grid: var HashSet[(int, int)], fold: string) =
    echo "handle fold ", fold
    let ds = fold.strip.split("=")
    let direction = ds[0]
    let val = ds[1].parseInt()
    var newSet = initHashSet[(int, int)]()
    if direction == "y":
        for pt in grid:
            let (x, y) = pt
            if y < val: 
                newSet.incl(pt)
                continue
            newSet.incl((x, val - (y - val)))
    if direction == "x":
        for pt in grid:
            let (x, y) = pt
            if x < val: 
                newSet.incl(pt)
                continue
            # echo "new X ", (val - (x - val))
            newSet.incl((val - (x - val), y))

    grid.clear()
    grid = newSet

proc displayGrid(grid: HashSet[(int, int)]) =
     var arr : array[40, array[40, char]]
     for x in 0..<arr.len:
        for y in 0..<arr[0].len:
            arr[x][y] = '.'
     for (x, y) in grid:
         arr[y][x] = '#'

     for x in 0..<arr.len:
        for y in 0..<arr[0].len:
            stdout.write arr[x][y]
        stdout.write '\n'

proc solve_a(input: string): int = 
     var (grid, folds) = populatePaper(input)
     let fold = folds[0]
     handleFold(grid, fold)

     result = grid.len

proc solve_b(input: string): int = 
     var (grid, folds) = populatePaper(input)
     for fold in folds:
        handleFold(grid, fold)

     displayGrid(grid)
     result = grid.len


let sample = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""

let input = readFile("./inputs/input13.txt").strip
echo solve_a(sample)
echo solve_b(sample)
echo solve_a(input)
echo solve_b(input)