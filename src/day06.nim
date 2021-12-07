import strutils, sequtils 

let sample = "3,4,3,1,2"

proc tick(lanterns: var openArray[int64], currentIndex: int) =
    let entry = currentIndex mod 9
    lanterns[(currentIndex + 7) mod 9] += lanterns[entry]

proc solve_a(input: string, iterations: int): int64 = 
    var lanterns = input.strip.split(",").mapIt(it.parseInt())
    var cyclesCount : array[9, int64]

    for l in lanterns:
        cyclesCount[l] += 1

    for i in 0..<iterations:
        tick(cyclesCount, i);
    
    return cyclesCount.foldl(a + b, cast[int64](0))

echo solve_a(sample, 80)
echo solve_a(sample, 256)

let input = readFile("./inputs/input6.txt").strip
echo "A: ", solve_a(input, 80)
echo "B: ", solve_a(input, 256)