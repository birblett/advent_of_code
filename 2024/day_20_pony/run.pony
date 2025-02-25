use "files"

actor Accumulator
  var _p1: I32
  var _p2: I32
  var _lim: I32
  var _progress: I32
  var _env: Env

  new create(lim: I32, env: Env) =>
    _lim = lim
    _env = env
    _p1 = 0
    _p2 = 0
    _progress = 0

  be inc(p1: I32, p2: I32) =>
    _p1 = _p1 + p1
    _p2 = _p2 + p2
    _progress = _progress + 1
    if _progress == _lim then _env.out.print("p1: " + _p1.string() + "\np2: " + _p2.string()) end

actor Coord
  var _x: I32
  var _y: I32

  new create(x: I32, y: I32) =>
    _x = x
    _y = y

  be calc(board: Array[Array[I32] val] val, acc: Accumulator) =>
    var i: I32 = -20
    var j: I32 = 0
    var res1: I32 = 0
    var res2: I32 = 0
    let curr: I32 = try board(USize.from[I32](_x))?(USize.from[I32](_y))? else 0 end
    while i < 21 do
      var k = I32.from[U32](j.abs()) + 1
      while j < k do
        try
          let saved = (board(USize.from[I32](_x + i))?(USize.from[I32](_y + j))? - curr) - (I32.from[U32](i.abs() + j.abs()))
          if saved > 99 then
            if (i.abs() + j.abs()) < 3 then res1 = res1 + 1 end
            res2 = res2 + 1
          end
        end
        j = j + 1
      end
      i = i + 1
      j = I32.from[U32](i.abs()) - 20
    end
    acc.inc(res1, res2)

  fun print(env: Env) => env.out.print("(" + _x.string() + "," + _y.string() + ")")

actor Main

  new create(env: Env) =>
    var board = Array[Array[I32]](0)
    var path = Array[Coord](0)
    var size: USize = 0
    var current: (I32, I32) = (0,0)
    var dest: (I32, I32) = (0,0)
    var last: (I32, I32) = (-2, -2)
    let dirs: Array[(I32, I32)] = [(-1, 0); (0, 1); (1, 0); (0, -1)]
    let f = File.open(FilePath(FileAuth(env.root), "in.txt"))
    for line in FileLines.create(f, 1) do
      var a = Array[I32](0)
      var cd: I32 = 0
      for c in line.string().array().values() do
        if c != '\n' then a.push(if c == '#' then -1000000 else 0 end) end
        if c == 'S' then current = (I32.from[USize](size), cd) end
        if c == 'E' then dest = (I32.from[USize](size), cd) end
        cd = cd + 1
      end
      board.push(a)
      size = size + 1
    end
    f.dispose()
    var count: I32 = 1
    path.push(Coord(current._1, current._2))
    try
      while not eqc(current, dest) do
        for d in dirs.values() do
          let tmp = addc(current, d)
          if (not eqc(tmp, last)) and (board(USize.from[I32](tmp._1))?(USize.from[I32](tmp._2))? == 0) then
            last = current
            current = tmp
            break
          end
        end
        path.push(Coord(current._1, current._2))
        board(USize.from[I32](current._1))?.update(USize.from[I32](current._2), count)?
        count = count + 1
      end
    end
    var p = recover trn Array[Array[I32] val] end
    for i in board.values() do
      var k = recover trn Array[I32] end
      for j in i.values() do k.push(j) end
      p.push(consume k)
    end
    var passable: Array[Array[I32] val] val = consume p
    let acc = Accumulator(count, env)
    for coord in path.values() do coord.calc(passable, acc) end

  fun addc(a: (I32, I32), b: (I32, I32)): (I32, I32) => (a._1 + b._1, a._2 + b._2)

  fun eqc(a: (I32, I32), b: (I32, I32)): Bool => (a._1 == b._1) and (a._2 == b._2)
