import strutils, sequtils, tables, sugar

type 
    PolyCount = array['A'..'Z', int64]
    Mapping = Table[(char, char), char]

var memoize: Table[(char, char, int), PolyCount]

proc calcPolyNumber(mapping: Mapping, charT: (char, char), level: int) : PolyCount =
    let (x, y) = charT
    if level == 0:
        result[x] = 1
        return

    if memoize.contains((x, y, level)):
        return memoize[(x, y, level)]

    let newC = mapping[charT]
    let p1 = calcPolyNumber(mapping, (x, newC), level - 1)
    memoize[(x, newC, level - 1)] = p1
    let p2 = calcPolyNumber(mapping, (newC, y), level - 1)
    memoize[(newC, y, level - 1)] = p2

    for i in low(p1)..high(p1):
        result[i] = p1[i] + p2[i]

    
proc solve_a(input: string, cycles: int): int64 = 
    memoize.clear()
    let lines = input.strip.splitLines()

    let start = lines[0]
    var mapping = initTable[(char, char), char]()

    for l in lines[2..^1]:
        let ls = l.strip.split(" -> ")
        mapping[(ls[0][0], ls[0][1])] = ls[1][0]

    var counts : PolyCount
    for i in countup(1, start.len() - 1):
        let p = (start[i-1], start[i])
        let c = calcPolyNumber(mapping, p, cycles)    
        for t in low(c)..high(c):
            counts[t] += c[t] 

    counts[start[^1]] += 1
    let ma = counts.filter(x => x != 0i64).max()
    let mi = counts.filter(x => x != 0i64).min()
    return ma - mi

let sample = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

echo solve_a(sample, 10)
echo solve_a(sample, 40)
let input = readFile("./inputs/input14.txt").strip
echo "A: ", solve_a(input, 10)
echo "B: ", solve_a(input, 40)