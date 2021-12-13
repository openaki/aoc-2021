import strutils, tables

proc createAdjList(input: string): Table[string, seq[string]] = 
    var ans = initTable[string, seq[string]]()
    for ln in input.strip.splitLines():
        let xs = ln.split("-")
        var curr = ans.getOrDefault(xs[0], @[])
        curr.add(xs[1])
        ans[xs[0]] = curr

        if xs[0] == "start": continue 

        curr = ans.getOrDefault(xs[1], @[])
        curr.add(xs[0])
        ans[xs[1]] = curr
    return ans

proc canRepeat(nodeName: string): bool = 
    for i in nodeName:
        if i >= 'A' and i <= 'Z':
            continue 
        return false
    return true

proc dfs(cur: string, graph: Table[string, seq[string]], seen: var Table[string, int], again: bool): int = 
    if cur == "end":
        return 1

    let cr = canRepeat(cur)
    if not cr: 
        let t = seen.getOrDefault(cur, 0)
        seen[cur] = t+1
    var paths = 0
    if graph.contains(cur):
        let lst = graph[cur]
        for l in lst:
            if not seen.contains(l):
                paths += dfs(l, graph, seen, again)
            elif again:
                paths += dfs(l, graph, seen, false)

    if seen.contains(cur): 
        seen[cur]-=1
        if seen[cur] == 0:
            seen.del(cur)

    return paths

proc solve_a(input: string, smallAllowed = 1): int = 
    let graph = createAdjList(input)
    var seen = initTable[string, int]()
    let paths = dfs("start", graph, seen, false)
    return paths

proc solve_b(input: string, smallAllowed = 1): int = 
    let graph = createAdjList(input)
    var seen = initTable[string, int]()
    var path : seq[string]
    var pathC = 0
    return dfs("start", graph, seen, true)
    #let smalls = graph.keys().filterIt(not it.canRepeat())
    #for k in graph.keys:
    #    if k == "start" or k == "end": continue
    #    if k.canRepeat(): continue 
    #    pathC += dfs("start", graph, seen, path, k)

let sample = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

let sample2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

let sample3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""


let input = """
GC-zi
end-zv
lk-ca
lk-zi
GC-ky
zi-ca
end-FU
iv-FU
lk-iv
lk-FU
GC-end
ca-zv
lk-GC
GC-zv
start-iv
zv-QQ
ca-GC
ca-FU
iv-ca
start-lk
zv-FU
start-zi
"""

echo solve_a(sample)
echo solve_b(sample)
echo solve_b(sample2)
echo solve_b(sample3)
echo solve_a(sample2)
echo solve_a(sample3)
echo "A: ", solve_a(input)
echo "B: ", solve_b(input)


