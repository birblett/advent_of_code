puts File.open("in.txt") { |file, ed = [0, 0], threadc = 8|
  "#{(out = file.map { |line| (ed = [[ed[0], (a = line.split(",").map(&:to_i))[1]].max, [ed[1], a[0]].max]) && a })[threadc.times.map { |tid, size = (ed[0] + 1)|
    Thread.new { |board = []|
      (ed[1] + 1).times { |i| (ed[0] + 1).times { board[i] = board.fetch(i, []) + [0] } }
      ((last = 0)..(out.length + threadc) / threadc).each { |r, queue = [[0, 0, 0]], min = nil, seen = {}|
        next if (r = r * threadc + tid) >= out.length
        (last..r).each { |r1| board[out[r1][1]][out[r1][0]] = 1 }
        while (y, x, steps = queue.pop)
          next if seen[(k = y * size + x)]
          seen[k] = steps
          board[y][x] = 3
          if ed == [y, x]
            min = steps
            break
          end
          [[y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]].each { |yy, xx|
            next if yy > ed[1] or xx > ed[0] or yy < 0 or xx < 0 or board[yy][xx] == 1
            queue.insert((idx = queue.bsearch_index { |b| steps + 1 > b[2] }) ? idx : -1, [yy, xx, steps + 1])
          }
        end
        (break (Thread.current[:res] = r) unless min) || (last = r + 1)
      }
    }
  }.map(&:join).min {|a, b| a[:res] <=> b[:res] }[:res]]}"
}