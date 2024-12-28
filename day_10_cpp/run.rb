puts File.open("in.txt") { |file, tscore = 0, paths = 0, len = nil, trailheads = []|
  board = file.each_with_index.map{ |str, y, _=(len = str.strip.length)|
    str.strip.chars.each_with_index.map { |c, x| trailheads.push((y << 8) + x) if c.ord == 48; c.ord - 48 }
  }.reduce(&:+)
  trailheads.each { |t, found = {}, q = [t], comp|
    (idx = (y1 = comp >> 8) * len + (x1 = comp & 255)
    if board[idx] == 9
      found[comp] = tscore += 1 unless found[comp]
      paths += 1
      next
    end
    [[y1 - 1, x1], [y1 + 1, x1], [y1, x1 - 1], [y1, x1 + 1]].each { |y2, x2|
      q.push((y2 << 8) + x2) if board[y2 * len + x2] == board[idx] + 1 unless y2 < 0 or y2 >= len or x2 < 0 or x2 >= len
    }) while (comp = q.pop)
  } && [tscore, paths]
}

puts File.open("in.txt") { |f, dim = ((f = f.map {_1.strip.chars.map { |s| s.ord - 48 } }.reduce(&:+)).length ** 0.5).to_i|
  tmat = (mat = f.each_with_index.reduce({}) { |sparse, (num, i), j|
    [[(y = i / dim) + 1, (x = i % dim)], [y - 1, x], [y, x + 1], [y, x - 1]].each {
      (sparse[i] = sparse.fetch(i, {}))[j] = 1 if (0...dim).include?(_1) && (0...dim).include?(_2) && f[j = _1 * dim + _2] == num + 1
    } && sparse
  }).reduce({}) { |hash, (k, v)| v.each { (hash[_1] = hash.fetch(_1, {}))[k] = _2 } && hash }
  (8).times {
    mat = mat.reduce({}) { |out, (r, v)| tmat.each { |c, v2, s = v2.sum { |k, v3| v[k] ? v3 * v[k] : 0 }|
      s > 0 ? (out[r] = out.fetch(r, {}))[c] = s : 0
    } && out }
  }
  [mat.sum { _2.size }, mat.sum { _2.values.sum }]
}