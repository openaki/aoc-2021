import std/sequtils
import std/sugar
import strutils

proc solve_a(numbers: seq[int]) : int =
    var count = 0
    for i in 1..<numbers.len:
        if (numbers[i] > numbers[i-1]):
            count += 1
    return count

proc main() =
    let nums = "./inputs/input1.txt".readFile().splitLines().map(x => x.parseInt())
    echo solve_a(nums)

main()

import unittest
test "test sample 1":
    let input = """
199
200
208
210
200
207
240
269
260
263    
    """;
    let nums = input.strip().splitLines().map(x => parseInt(x))
    check solve_a(nums) == 7


