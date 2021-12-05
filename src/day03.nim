import strutils
import sequtils
import std/enumerate
import sugar
import std/sets

let sample = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

proc calcZeroCheck[T](inputs: T) : seq[bool] =
    var zeroCount : seq[int] = @[]
    var totalNumbers = 0

    for line in inputs:
        totalNumbers += 1
        for i, c in enumerate(line):
            if totalNumbers == 1:
                zeroCount.add(0)
            if c == '0':
                zeroCount[i] += 1

    let zeroSeq = zeroCount.map(z => z > (totalNumbers div 2))
    return zeroSeq

proc solve_a(input: string) : (int, seq[bool]) = 
    var zeroCount : seq[int] = @[]
    var totalNumbers = 0

    let zeroCheck = calcZeroCheck(input.strip().splitLines())

    echo totalNumbers, zeroCount 
    var epsilon = 0;
    var gamma = 0;
    for z in zeroCheck:
        epsilon = epsilon shl 1
        gamma = gamma shl 1
        if z:
            gamma += 1;
        else:
            epsilon += 1;

    echo epsilon, " " , gamma 

    let zeroSeq = zeroCount.map(z => z > (totalNumbers div 2))
    return ((epsilon * gamma), zeroSeq)
                

proc solve_b(input: string): int = 

    let inputLines = input.strip().splitLines()
    var remainingO2 : HashSet[string] = toHashSet(inputLines)
    var remainingCO2 = remainingO2

    let numChars = inputLines[0].len()
    for i in 0..<numChars:
        var newO2Set = initHashSet[string]()
        var newCO2Set = initHashSet[string]()

        if remainingO2.len() > 1:
            let zeroCheckO2 = calcZeroCheck(remainingO2)
            for line in remainingO2:
                if line[i] == '0' and zeroCheckO2[i]:
                    newO2Set.incl(line)
                if line[i] == '1' and not zeroCheckO2[i]:
                    newO2Set.incl(line)
            remainingO2 = newO2Set

        if remainingCO2.len() > 1:
            let zeroCheckCO2 = calcZeroCheck(remainingCO2)
            for line in remainingCO2:
                if line[i] == '0' and not zeroCheckCO2[i]:
                    newCO2Set.incl(line)
                if line[i] == '1' and zeroCheckCO2[i]:
                    newCO2Set.incl(line)
        
            remainingCO2 = newCO2Set

    let o2Val = remainingO2.toSeq()[0].parseBinInt()
    let co2Val = remainingCO2.toSeq()[0].parseBinInt()
    return o2Val * co2Val

proc main() =
    let input = readFile("./inputs/input3.txt").strip()

    block:
        let (ans, zeroCount) = solve_a(sample)
        echo "Sample A: ", ans
        echo solve_b(sample)
    block:
        let ans, zeroCount = solve_a(input)
        echo "A: ", ans
        echo solve_b(input)

main()
