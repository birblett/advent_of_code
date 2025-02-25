import std/streams
import std/sets
import std/deques
import std/strutils
import std/sequtils
import std/times
import std/monotimes

let a = getMonoTime()

const (size_x, size_y, iter) = (70, 70, 1024)
const dest = (size_x, size_y)
func in_bounds(c: (int, int)): bool = c[0] >= 0 and c[1] >= 0 and c[0] <= size_x and c[1] <= size_y
func to_c(c: (int, int)): int = c[0] + c[1] * (size_y + 1)
func addc(c1: (int, int), c2: (int, int)): (int, int) = (c1[0] + c2[0], c1[1] + c2[1])

let strm = newFileStream("in.txt", fmRead)
var lines: seq[string]
for line in strm.lines(): lines.add line
let dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
strm.close()

let ls = lines.map(proc(s: string): (int, int) = (let a = split(s, ",").map parseInt; (a[0], a[1])))
var board: array[to_c((size_x + 1, size_y + 1)), int]
for i in 0..iter - 1: board[to_c(ls[i])] = 1
var cset: HashSet[(int, int)]
var q = [(0, 0, 0)].toDeque
var steps = 0

while q.len > 0:
  var tmp = q.popFirst
  var c = (tmp[0], tmp[1])
  if c in cset: continue
  if c == dest: steps = tmp[2]; break
  cset.incl c
  for d in dirs:
    var next = addc(c, d)
    if in_bounds(next) and board[to_c(c)] != 1:
      q.addLast((next[0], next[1], tmp[2] + 1))

echo steps

for i in 0..ls.len - 1: board[to_c(ls[i])] = 0
let adjacent = [(-1, 0), (0, 1), (1, 0), (0, -1), (-1, 1), (1, 1), (1, -1), (-1, -1)]

for coord in ls:
  var set: array[to_c((size_x + 1, size_y + 1)), int]
  var q = [coord].toDeque
  var max_x, max_y = 0
  var cont = false
  board[to_c(coord)] = 1
  while q.len > 0:
    var tmp = q.popLast
    var c = (tmp[0], tmp[1])
    var cd = to_c(c)
    if set[cd] == 1: continue
    else: set[cd] = 1
    (max_x, max_y) = (max(c[0], max_x), max(c[1], max_y))
    if max_x == size_x and max_y == size_y: cont = true; break
    for d in adjacent:
      var next = addc(c, d)
      if in_bounds(next) and board[to_c(next)] != 0:
        q.addLast(next)
  if cont:
    echo coord
    break

let b = getMonoTime()
echo "completed in ", (b - a).inNanoseconds / 1000000, "ms"