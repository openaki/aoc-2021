import sequtils, strutils, sugar, deques, algorithm
let sample = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

proc solve_a(input: string): int = 
    var nums = input.strip.splitLines;
    let grid = nums.mapIt(it.toSeq())
    let maxX = grid.len
    let maxY = grid[0].len

    for i in countup(0, maxX-1):
        for j in countup(0, maxY-1):
            let cur = grid[i][j]
            if i > 0 and grid[i-1][j] <= cur: continue
            if i < maxX-1 and grid[i+1][j] <= cur: continue
            if j > 0 and grid[i][j-1] <= cur: continue
            if j < maxY-1 and grid[i][j+1] <= cur: continue

            result += int(cur) - int('0') + 1

type
    Point = object
        x,y: int

proc bfs(start: (int, int), grid: seq[seq[char]], seen: var seq[seq[bool]]) : int= 
    let (i, j) = start
    if (seen[i][j]): return

    let maxX = grid.len
    let maxY = grid[0].len

    var q = initDeque[(int, int)]()

    q.addLast(start)

    while q.len != 0:
        let (i, j) = q.popFirst()
        if (seen[i][j]): continue

        seen[i][j] = true
        result += 1

        if i > 0 and grid[i-1][j] != '9': q.addLast((i-1, j))

        if i < maxX-1 and grid[i+1][j] != '9': q.addLast((i+1, j))
        if j > 0 and grid[i][j-1] != '9': q.addLast((i, j-1))
        if j < maxY-1 and grid[i][j+1] != '9': q.addLast((i, j+1))


proc solve_b(input: string): int = 
    var nums = input.strip.splitLines
    let grid = nums.mapIt(it.toSeq())
    let maxX = grid.len
    let maxY = grid[0].len
    var basinSeen = grid.map(x => x.mapIt(false));

    var ans = @[0]
    for i in countup(0, maxX-1):
        for j in countup(0, maxY-1):
            let cur = grid[i][j]
            if i > 0 and grid[i-1][j] <= cur: continue
            if i < maxX-1 and grid[i+1][j] <= cur: continue
            if j > 0 and grid[i][j-1] <= cur: continue
            if j < maxY-1 and grid[i][j+1] <= cur: continue

            ans.add(bfs((i, j), grid, basinSeen))

    ans.sort(SortOrder.Descending)
    return ans[0] * ans[1] * ans[2]


echo solve_a(sample)
echo solve_b(sample)
let input = readFile("./inputs/input9.txt")
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)
