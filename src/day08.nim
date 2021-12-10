import sequtils, strutils, algorithm
import sets

let sample = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

let sample1 = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"

proc solve_a(input: string): int = 
    let lines = input.strip.splitLines
    for line in lines:
        let tokens = line.split("|")
        let outputVal = tokens[1]
        for tok in outputVal.strip.splitWhitespace:
            let t = tok.strip
            if t.len == 2 or t.len == 4 or t.len == 7 or t.len == 3:
                result += 1

proc solve_b(input: string): int = 
    let lines = input.strip.splitLines
    for line in lines:
        let tokens = line.split("|")
        let inputs = tokens[0].strip.splitWhitespace.mapIt(it.toHashSet)
        let outputs = tokens[1].strip.splitWhitespace.mapIt(it.toHashSet)
        var nums: array[10, HashSet[char]]
        for i in inputs: 
            if i.len == 2: nums[1] = i
            if i.len == 3: nums[7] = i
            if i.len == 4: nums[4] = i
            if i.len == 7: nums[8] = i

        for i in inputs:
            if i.len == 6 and not(nums[1]<i): nums[6] = i
            elif i.len == 6 and nums[4] < i: nums[9] = i
            elif i.len == 6 : nums[0] = i

            if i.len == 5 and nums[1]<i: nums[3] = i
        
        for i in inputs:
            let x = nums[3] - nums[6]
            if i.len == 5 and nums[1]<i: nums[3] = i
            elif i.len == 5 and x < i: nums[2] = i
            elif i.len == 5 : nums[5] = i

        var oNum = 0
        for o in outputs:
            for i in countup(0, 9, 1):
                if o == nums[i]: 
                    oNum *= 10
                    oNum += i

        result += oNum

echo solve_a(sample)
echo solve_b(sample)
let input = readFile("./inputs/input8.txt").strip
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)
