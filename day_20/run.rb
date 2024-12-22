puts File.open("in.txt") { |file, queue = [], laststeps = [], y = nil, x = nil, cheat = nil|
  board = file.each_with_index.map { |line, i| line.strip.chars.each_with_index.map { |c, j| (c == "S" ? (queue = [[i, j]]) : 0) && c } }
  (laststeps.push([y, x])
  board[y][x] = "#"
  [[y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]].each { |yy, xx| (queue.push([yy, xx]); break) if board[yy][xx] != "#" }) while (y, x, = queue.pop)
  laststeps.each_with_index.reduce([0, 0]) { |out, (coord, idx)|
    (idx + 1...laststeps.length).each { |idx2|
      (out[1] += 1) && (out[0] += 1 if cheat <= 2) unless (cheat = ((coord2 = laststeps[idx2])[0] - coord[0]).abs + (coord2[1] - coord[1]).abs) > 20 or (idx2 - idx - cheat) < 100
    } && out
  }
}