import sequtils, strutils, sugar

type 
    PacketKind = enum
        Literal, Operator

    Packet = object  
        case kind: PacketKind 
        of Literal: litVal: int64
        of Operator: opVals: seq[Message]

    Message = object 
        version: int8
        packetType: int8
        packet: Packet
        msgLen: int

var parseMessage: proc(bits: string) : Message 

proc parseOperator(bits: string) : seq[Message] =

    if bits[0] == '0':
        var length = parseBinInt(bits[1..15])
        var msgStart = 15 + 1
        while length > 0:
            let p = parseMessage(bits[msgStart..^1])
            result.add(p)
            msgStart += p.msgLen
            length -= p.msgLen

    elif bits[0]  == '1':
        var numMsgs = parseBinInt(bits[1..11])
        var msgStart = 11 + 1
        for i in countup(1, numMsgs):
            let p = parseMessage(bits[msgStart..^1])
            result.add(p)
            msgStart += p.msgLen

# returns the literal and bits consumed
proc parseLiteral(bits: string) : (int64, int) = 
    var bitC = 0
    var num :int64
    while true:
        num = num shl 4
        num += parseBinInt(bits[bitc+1..bitc+4])
        if (bits[bitc] == '0'): break
        bitc += 5

    return (num, bitc + 5)

parseMessage = proc(bits: string) : Message = 
    let version = int8(parseBinInt(bits[0..2]))
    let packetType = int8(parseBinInt(bits[3..5]))
    case packetType
    of 4: 
        let (lit, bitsConsumed) = parseLiteral(bits[6..^1])
        #let bc = (((bitsConsumed + 6) div 8) + 1) * 8
        let bc = (bitsConsumed + 6) 
        return Message(version: version, packetType: packetType, packet: Packet(kind: Literal, litVal: lit), msgLen: bc)
    else: 
        let msgs = parseOperator(bits[6..^1])
        var bc = 7
        if bits[6] == '0':
            bc += 15
        else:
            bc += 11
        for m in msgs:
            bc += m.msgLen
        return Message(version: version, packetType: packetType, packet: Packet(kind: Operator, opVals: msgs), msgLen: bc)

proc parseHex(hexS: string): Message = 
    let bits = (parseHexStr(hexS.strip)).toSeq().map(x => toBin(int16(x), 8)).foldl(a & b, "")
    parseMessage(bits)

proc versionSum(msg: Message): int =
    case msg.packet.kind 
    of Literal: return msg.version
    of Operator:
        var ans = int(msg.version)
        for m in msg.packet.opVals:
            ans += versionSum(m)
        return ans

proc calcExpr(msg: Message): int64 =
    case msg.packet.kind 
    of Literal: 
        return msg.packet.litVal
    of Operator:
        case msg.packetType:
        of 0: 
            for m in msg.packet.opVals:
                result += calcExpr(m)
            return
        of 1: 
            result = 1
            for m in msg.packet.opVals:
                result *= calcExpr(m)
            return
        of 2: 
            result = int64.high()
            for m in msg.packet.opVals:
                result = min(result, calcExpr(m))
            return
        of 3: 
            result = int64.low()
            for m in msg.packet.opVals:
                result = max(result, calcExpr(m))
            return
        of 5: 
            let a = calcExpr(msg.packet.opVals[0])
            let b = calcExpr(msg.packet.opVals[1])
            result = 0
            if a > b: result = 1
            return
        of 6: 
            let a = calcExpr(msg.packet.opVals[0])
            let b = calcExpr(msg.packet.opVals[1])
            result = 0
            if a < b: result = 1
            return
        of 7: 
            let a = calcExpr(msg.packet.opVals[0])
            let b = calcExpr(msg.packet.opVals[1])
            result = 0
            if a == b: result = 1
            return
        else: echo "Not defined"


proc solve_a(hexS: string): int =
    let m = parseHex(hexS)
    return versionSum(m)

proc solve_b(hexS: string): int64 =
    let m = parseHex(hexS)
    return calcExpr(m)


let sample1 = """
D2FE28
38006F45291200
EE00D40C823060
"""
let sample2 = """
8A004A801A8002F478
620080001611562C8802118E34
C0015000016115A2E0802F182340
A0016C880162017C3686B18A3D4780
"""

let sample3 = """
C200B40A82
04005AC33890
880086C3E88112
CE00C43D881120
D8005AC2A8F0
F600BC2D8F
9C005AC2F8F0
9C0141080250320F1802104A08
"""

for s in sample1.strip().splitLines():
    echo solve_a(s)

for s in sample2.strip().splitLines():
    echo solve_a(s)

for s in sample3.strip().splitLines():
    echo solve_b(s)

let input = readFile("./inputs/input16.txt")

echo "A: ", solve_a(input)
echo "B: ", solve_b(input)