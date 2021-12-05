import sequtils;
import strutils;
import std/enumerate;
import sugar
import itertools
import sets

type
    Board = object 
        board: array[5, array[5, int]]
        crossed: array[5, array[5, int8]]


proc crossNumber(board: var Board, number: int) = 
    for i in 0..<5:
        for j in 0..<5:
            if (board.board[i][j] == number):
                board.crossed[i][j] = 1
                return

func hasWon(board: Board): bool = 
    # first check the rows 
    for i in 0..<5:
        let sum = board.crossed[i].foldl(a + b, 0)
        if (sum == 5):
            return true;
    
    for i in 0..<5:
        var sum = 0
        for j in 0..<5:
            sum += board.crossed[j][i]
            if (sum == 5):
                return true;

    return false

func sum(board: Board): int = 
    for i in 0..<5:
        for j in 0..<5:
            if board.crossed[i][j] == 0:
                result += board.board[i][j]
    

func parseBoard(input: openArray[string]) : Board = 
    var b = Board()
    for i in 0..<5:
        let line = input[i]
        for index, j in enumerate(line.strip().splitWhitespace()):
            b.board[i][index] = j.parseInt()
    return b

proc parseBoards(input: seq[string]): seq[Board] = 
    return input.chunked(6).toSeq.map(x => parseBoard(x))

let sample = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

proc solve_a(input: string, firstWin: bool):int =
    let lines = input.strip().splitLines().toSeq()
    let moves = lines[0].strip().split(",") .mapIt(parseInt(it))
    var boards = parseBoards(lines[2..^1])

    var lastBoardSum = 0
    var lastNumber = 0
    var wonSet : HashSet[int] = initHashSet[int]()
    for m in moves:
        for i, b in enumerate(boards.mitems):
            if wonSet.contains(i):
                continue
            b.crossNumber(m)
            if b.hasWon():
                wonSet.incl(i)
                lastBoardSum = b.sum()
                lastNumber = m
                if firstWin:
                    return lastBoardSum * lastNumber
    return lastNumber * lastBoardSum


echo "Sample ", solve_a(sample, true)
echo "Sample ", solve_a(sample, false)
let input = readFile("./inputs/input4.txt")
echo "A ", solve_a(input, true)
echo "B ", solve_a(input, false)
    