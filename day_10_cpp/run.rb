puts File.open("in.txt") { |file, tscore = 0, paths = 0, len = nil, trailheads = []|
  board = file.each_with_index.map{ |str, y, _=(len = str.strip.length)|
    str.strip.chars.each_with_index.map { |c, x| trailheads.push((y << 8) + x) if c.ord == 48; c.ord - 48 }
  }.reduce(&:+)
  trailheads.each { |t, found = {}, q = [t], comp|
    (idx = (y1 = comp >> 8) * len + (x1 = comp & 255)
    if board[idx] == 9
      found[comp] = tscore += 1 unless found[comp]
      paths += 1
    else
      [[y1 - 1, x1], [y1 + 1, x1], [y1, x1 - 1], [y1, x1 + 1]].each { |y2, x2|
        q.push((y2 << 8) + x2) if board[y2 * len + x2] == board[idx] + 1 unless y2 < 0 or y2 >= len or x2 < 0 or x2 >= len
      }
    end) while (comp = q.pop)
  } && [tscore, paths]
}