=begin
File.open("in.txt") { |file|
  trailheads = []
  a = file.map(&:strip).map(&:chars).each_with_index.map { |l, i| l.each_with_index.map { |c, j|
    trailheads.push([i, j, 0]) if c == "0"
    c == "." ? -1 : c.to_i }
  }
  len = a.length
  graph = {}
  targets = {}
  trailheads.each { |y, x, _|
    q = [[[y - 1, x, 1], [y, x, 0]], [[y + 1, x, 1], [y, x, 0]], [[y, x - 1, 1], [y, x, 0]], [[y, x + 1, 1], [y, x, 0]]]
    visited = {}
    while (arr = q.pop)
      (y1, x1, target) = arr[0]
      next if y1 < 0 or y1 >= len or x1 < 0 or x1 >= len or a[y1][x1] != target
      if a[y1][x1] == 9 or visited[[y1, x1]]
        arr.each_with_index { |(y2, x2, d), i|
          next if i == arr.length - 1
          y3, x3, e = arr[i + 1]
          k = [y2, x2, d]
          k2 = [y3, x3, e]
          graph[k] = [] unless graph[k]
          graph[k].push(k2) unless graph[k].include?(k2)
          targets[k] = true if d == 9
        }
        next visited[[y1, x1]] = true
      end
      visited[[y1, x1]] = true
      q.push([[y1 + 1, x1, target + 1]] + arr, [[y1 - 1, x1, target + 1]] + arr, [[y1, x1 + 1, target + 1]] + arr, [[y1, x1 - 1, target + 1]] + arr)
    end
  }
  scores = {}
  targets.keys.each { |t|
    scores[t] = 1
    stack = graph[t].clone
    while (node = stack.pop)
      scores[node] = 0 unless scores[node]
      scores[node] += 1
      stack += graph[node] if graph[node]
    end
  }
  puts trailheads.sum { |t| scores[t] }
}
=end
def point(comp)
  puts "#{comp >> 8} #{comp & 255}"
end

# &255 << 8
File.open("in.txt") { |file, tscore = 0, paths = 0, len = nil, trailheads = []|
  board = file.each_with_index.map{ |str, y|
    len = str.strip.length unless len
    str.strip.chars.each_with_index.map { |c, x|
      trailheads.push((y << 8) + x) if c.ord == 48; c.ord - 48
    }
  }.reduce(&:+)
  trailheads.each { |t, found = {}|
    q = [t]
    while (comp = q.pop)
      idx = (y1 = comp >> 8) * len + (x1 = comp & 255)
      puts "#{q.length} #{y1} #{x1}"
      if board[idx] == 9
        found[comp] = tscore += 1 unless found[comp]
        paths += 1
        next
      end
      [[y1 - 1, x1], [y1 + 1, x1], [y1, x1 - 1], [y1, x1 + 1]].each { |y2, x2|
        q.push((y2 << 8) + x2) if board[y2 * len + x2] == board[idx] + 1 unless y2 < 0 or y2 >= len or x2 < 0 or x2 >= len
      }
    end
  }
  puts tscore, paths
}