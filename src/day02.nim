import strutils
import sequtils

type
    CommandKind = enum  
        Up, Down, Fwd 
    Command = object 
        case kind: CommandKind 
        of Up: upVal: int
        of Down: downVal: int
        of Fwd: fwdval: int


proc parseCommand(line: string) : Command = 
    let s = line.splitWhitespace()
    case s[0]
    of "forward": return Command(kind: Fwd, fwdVal: s[1].parseInt())
    of "down": return Command(kind: Down, downVal: s[1].parseInt())
    of "up": return Command(kind: Up, upVal: s[1].parseInt())

proc parseCommands(input: string): seq[Command] = 
    return input.strip().splitLines().map(parseCommand)

proc solve_a(cmds: seq[Command]): int =
    var hor = 0
    var ver = 0
    for c in cmds:
        case c.kind 
        of Down: ver += c.downVal
        of Up: ver -= c.upVal
        of Fwd: hor += c.fwdVal
    return hor * ver

proc solve_b(cmds: seq[Command]): int =
    var hor = 0
    var ver = 0
    var axis = 0
    for c in cmds:
        case c.kind 
        of Down: axis += c.downVal
        of Up: axis -= c.upVal
        of Fwd: 
            hor += c.fwdVal
            ver += c.fwdval * axis

    return hor * ver 

let b1 = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

let input = readFile("./inputs/input2.txt")
echo "A ", solve_a(parseCommands(input))
echo "B ", solve_b(parseCommands(input))

import unittest


test "solve a":
    assert 150 == solve_a(parseCommands(b1))


test "solve b":
    assert 900 == solve_b(parseCommands(b1))