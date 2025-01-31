b, moves, c1, c2, dirs = File.read("in.txt").split("\n\n") + [nil, nil, [[0, -1], [-1, 0], [0, 1], [1, 0]]]
board1, board2 = b.split("\n").each_with_index.reduce([[], []]) { |(b1, b2), (line, i)| [b1 + [line.gsub("@", ".").chars], b2 + [line.chars.each_with_index.map {|c, j| c == "@" ? (c1 = [i, j]) && (c2 = [i, j * 2]) && ".." : c == "O" ? "[]" : c * 2}.join.split("")]] }
puts moves.split("\n").join.chars.map { |c| c == "v" ? 3 : c.ord % 3 }.each { |c, dir = dirs[c], p|
  c1, c2 = [[board1, c1], [board2, c2]].map { |board, coord, nxt = [coord[0] + (dy = dir[0]), coord[1] + (dx = dir[1])], move = [[nxt[0], nxt[1]]], found_move = { nxt[0] + (nxt[1] << 8) => true }, to_move = [], should_move = true|
    while (y, x = move.shift) && (should_move = board[y][x] != "#") && (ny, nx = y + dy, x + dx)
      (move.push([y, p]) && (found_move[y + (p << 8)] = true) unless board[y][x] == "O" || found_move[y + ((p = x + (board[y][x] == "[" ? 1 : -1)) << 8)]
      move.push([ny, nx]) && (found_move[ny + (nx << 8)] = true) unless board[y][x] != "O" && (nx == p || found_move[ny + (nx << 8)])
      to_move += [[y, x, ny, nx, board[y][x]]]) unless board[y][x] == "."
    end
    should_move ? to_move.reverse.each { |y1, x1, y2, x2, ch| board[y2][x2], board[y1][x1] = ch, "."} && nxt : coord
  }
} && [board1, board2].map { _1.each_with_index.sum { |line, i| line.each_with_index.sum { |c, j| "O["[c] ? i * 100 + j : 0 } } }