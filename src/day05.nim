import sequtils, strutils

let sample = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""
type 
    Point = object  
        x, y: int
    Line = object
        b, e: Point

func toPoint(arr: openArray[string]): Point = 
    let x = arr[0].parseInt
    let y = arr[1].parseInt
    return Point(x: x, y: y)

func toLine(arr: openArray[Point]): Line = 
    return Line(b: arr[0], e: arr[1])

func isDiagonal(b, e: Point): bool = 
    if abs(b.x - e.x) == abs(b.y - e.y): return true

    return false

proc getLines(input: string): seq[Line] = 
    for l in input.strip.splitLines:
        result.add(l.split("->").mapIt(it.strip.split(",").toPoint).toLine)

proc solve_a(input: string, considerDiag: bool): int = 
    let lines = getLines(input)
    # cheat .. assume a grid of 1000
    var grid : array[1000, array[1000, int]]
    var pts = 0;
    for l in lines:
        var dx = (l.e.x - l.b.x)
        var dy = (l.e.y - l.b.y)
        if dx != 0: dx = dx div abs(dx) 
        if dy != 0: dy = dy div abs(dy) 
        var startx = l.b.x
        var starty = l.b.y
        if (dx == 0 or dy == 0) or (considerDiag and isDiagonal(l.b, l.e)):
            while startx != (l.e.x + dx) or starty != (l.e.y + dy):
                grid[startx][starty] += 1
                if grid[startx][starty] == 2:
                    pts += 1
                startx += dx
                starty += dy
        
    return pts

let input = readFile("./inputs/input5.txt").strip
echo solve_a(sample, false)
echo solve_a(sample, true)
echo "A ", solve_a(input, false)
echo "B ", solve_a(input, true)

