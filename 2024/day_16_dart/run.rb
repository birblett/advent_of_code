puts File.open("in.txt") { |file, queue = [], seen = {}, ed = nil, size = 0, dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]], walked = {}, min, y, x, d, steps, last|
  board = file.each_with_index.map { |line, i| (size = line.strip.length) && line.strip.chars.each_with_index.map { |c, j|
    c == "S" ? (queue = [[i, j, 1, 0, [i, j, nil]]]) && 0 : c == "E" ? (ed = i * size + j) - ed : c == "#" ? 1 : 0
  } }.reduce(&:+)
  (next if seen[(k = 10 * (y * size + x) + (dirs[d][0] << 1) + dirs[d][1])] && steps > seen[k]
  seen[k] = steps
  if ed == y * size + x
    break if min and min != steps
    walked[min = steps] = (walked[min] ? walked[min] : []) + [last]
    next
  end
  [[d, steps + 1], [(d + 1) & 3, steps + 1001], [(d + 3) & 3, steps + 1001]].each { |dd, steps2|
    if board[(yy = y + dirs[dd][0]) * size + (xx = x + dirs[dd][1])] == 0
      idx = queue.bsearch_index { |b| steps2 > b[3] }
      queue.insert(idx ? idx : -1, [yy, xx, dd, steps2, [xx, yy, last]])
    end
  }) while (y, x, d, steps, last = queue.pop)
  (h = {}) && walked[min].each { |n| (0..).each { (break unless n) or (h[n[0] * size + n[1]] = true) and (n = n[2]) } } && [min, h.length + 1]
}