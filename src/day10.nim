import sequtils, strutils, deques, algorithm

let sample = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

proc solve_a(input: string): int = 
    let lines = input.strip.splitLines()

    var stack = initDeque[char]()
    for l in lines:
        for c in l:
            if c == '[' or c == '(' or c == '{' or c == '<': 
                stack.addLast(c)
                continue
            let last = stack.popLast()
            if last == '[' and c == ']': continue
            if last == '(' and c == ')': continue
            if last == '<' and c == '>': continue
            if last == '{' and c == '}': continue

            case c 
            of ')': result += 3
            of ']': result += 57
            of '}': result += 1197
            of '>': result += 25137
            else: result += 0
                
            break;

proc solve_b(input: string): int = 
    let lines = input.strip.splitLines()

    var stack = initDeque[char]()
    var completionScores = newSeq[int](0)
    for l in lines:
        var corrupt = false
        stack.clear
        for c in l:
            if c == '[' or c == '(' or c == '{' or c == '<': 
                stack.addLast(c)
                continue
            let last = stack.popLast()
            if last == '[' and c == ']': continue
            if last == '(' and c == ')': continue
            if last == '<' and c == '>': continue
            if last == '{' and c == '}': continue

            corrupt = true
            break;
        if corrupt: continue

        var completionScore = 0
        for c in stack.toSeq.reversed:
            case c
            of '(': completionScore = (completionScore * 5) + 1
            of '[': completionScore = (completionScore * 5) + 2
            of '{': completionScore = (completionScore * 5) + 3
            of '<': completionScore = (completionScore * 5) + 4
            else: discard

        completionScores.add(completionScore)
    completionScores.sort()
    return completionScores[completionScores.len div 2]



echo solve_a(sample)
echo solve_b(sample)
let input = readFile("./inputs/input10.txt").strip
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)
