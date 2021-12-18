import strutils, sequtils, sugar

proc getMinCost(grid: seq[seq[int]]): int =
    var costs = grid.map(x => x.toSeq.map(x=>int.high))
    var changed = true

    while changed:
        changed = false
        for i in countup(0, grid.len() - 1):
            for j in countup(0, grid[0].len() - 1):

                if i == 0 and j == 0:
                    costs[i][j] = 0
                    continue

                var maxPathCost = int.high

                if (i > 0): maxPathCost = min(maxPathCost, costs[i - 1][j])
                if (j > 0): maxPathCost = min(maxPathCost, costs[i][j - 1])
                if (i < grid.len() - 1): maxPathCost = min(maxPathCost, costs[i + 1][j])
                if (j < grid[0].len() - 1): maxPathCost = min(maxPathCost, costs[i][j + 1])
                let oldCost = costs[i][j]
                costs[i][j] = grid[i][j] + maxPathCost
                if oldCost != costs[i][j]:
                    changed = true


    costs[^1][^1]

proc solve_a(input: string): int = 
    let grid = input.strip.splitLines().map(x => x.toSeq.map(x=>cast[int](x) - cast[int]('0')))
    return getMinCost(grid)

proc incrementRisk(r: seq[int], times: int): seq[int] =
    result = r
    for i in countup(0, r.len() - 1):
        let x = r[i]
        if x + times > 9: result[i] = times - (9 - x) 
        else: result[i] = x + times

proc solve_b(input: string): int = 
    let tile = input.strip.splitLines().map(x => x.toSeq.map(x=>cast[int](x) - cast[int]('0')))
    var grid = tile

    # first get the columns correct
    for r in countup(0, grid.len() - 1):
        for i in countup(1, 4):
            let tr = tile[r]
            grid[r].add(incrementRisk(tr, i))

    # not get the rows correct
    let rowTile = grid[0..^1]
    for i in countup(1, 4):
        for r in countup(0, rowTile.len() - 1):
            let tr = rowTile[r]
            grid.add(incrementRisk(tr, i))


    # for i in countup(0, grid.len() - 1):
    #     for j in countup(0, grid[0].len() - 1):
    #         stdout.write(grid[i][j])
    #     stdout.write("\n")
    return getMinCost(grid)

let sample = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""


echo solve_a(sample)
echo solve_b(sample)
let input = readFile("./inputs/input15.txt").strip
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)

discard """
11637517422274862853338597396444961841755517295286
11637517422274862853338597396444961841755517295286 6628316397
1163751742116375174222748628533385973964449618417555172952866628316397
"""
