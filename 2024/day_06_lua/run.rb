puts File.open("in.txt") { |file, board = (file.read.split("\n").join), size = board.length, len = (size ** 0.5).to_i, tg = (len - 1), start = (coord = board.index("^")), dir = 0, dirs = [-len, 1, len, -1]|
  board, iter, path, cache, bad, tmp, cached = board.chars.map { _1 == "#" ? 0 : 1 }, 0, 0, board.chars.map { 0 }, bad = 0, coord, board.chars.map { 0 }
  ((if board[tmp] == 0
    (dir = (dir + 1) & 3)
  else
    (if board[tmp] != 2
      (path += 1) && (board[tmp], iter, tcoord, tdir, badc, ttmp = 2, iter + 1, coord, dir, tmp, nil)
      (board[ttmp] == 0 || ttmp == badc ? (tdir = (tdir + 1) & 3) : cache[ttmp] == (hash = tdir + (tcoord << 2) + (iter << 10)) ? (bad += 1) && (cached[badc] += 1) && break : (cache[(tcoord = ttmp)] = hash)
      ) while (ttmp = tcoord + dirs[tdir]) && (tdir & 1 == 0 ? ttmp >= 0 && ttmp < size : (x = tcoord % len + dirs[tdir]) < len && x >= 0) if coord != start
    end) ^ (coord = tmp)
  end) while (tmp = coord + dirs[dir]) && (dir & 1 == 0 ? tmp >= 0 && tmp < size : (x = coord % len + dirs[dir]) < len && x >= 0)) || [path, bad]
}