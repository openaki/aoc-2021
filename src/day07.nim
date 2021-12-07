import sequtils, strutils
let sample = "16,1,2,0,4,2,7,1,2,14"

proc solve_a(input: string, variable: bool) : int = 
    let nums = input.strip.split(",").mapIt(it.parseInt)

    let st = nums.min()
    let en = nums.max()

    var bestCost = int.high
    for x in st..en:
        var cost = 0
        for i in nums:
            if variable:
                let n = abs(i - x)
                cost += (n * (n+1)) div 2
            else:
                cost += abs(i - x)
        bestCost = min(cost, bestCost)

    return bestCost

echo solve_a(sample, false)
echo solve_a(sample, true)
let input = readFile("./inputs/input7.txt").strip
echo solve_a(input, false)
echo solve_a(input, true)

