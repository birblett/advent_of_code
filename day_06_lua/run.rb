require '../timer'
=begin
timed do
File.open("in.txt") { |file, guard = nil, threadc = 1, threads = [], len = 0|
  (b = file.each_with_index.map { |l, i| (len = l.strip.length) and l.strip.chars.each_with_index.map { |c, j| c == "#" ? nil : c == "^" ? ((guard = [i, j]) and 1) : 0 } }.reduce(&:+)) and
  (0...threadc).each { |i, dirs = {0 => [-1, 0], 1 => [0, 1], 2 => [1, 0], 3 => [0, -1]}|
    threads.push Thread.new { |local = 0, visited = 0|
      (i * len / threadc...[(i + 1) * len / threadc, len].min).each { |y|
        (0..len).each { |x, gy = guard[0], gx = guard[1], dir = 0, edge = {}, last = 0|
          next unless b[len * y + x]
          b1 = (gy == y && gx == x)
          (0..).each {
            y1, x1 = gy + dirs[dir][0], gx + dirs[dir][1]
            break if (y1 < 0 or y1 >= len or x1 < 0 or x1 >= len)
            if (b1 or y1 != y or x1 != x) and b[idx = y1 * len + x1]
              (visited += (b[idx] = 1)) if (gy, gx = y1, x1) and b1 and b[idx] == 0
            else
              k = (last << 14) + (gy << 7) + gx
              (local += 1; break) if edge[k]
              dir = dir + 1 & 3
              edge[k] = true
              last = (gy << 7) + gx
            end
          }
        }
      }
      (Thread.current[:bad], Thread.current[:visit] = local, visited)
    }
  }
  a = threads.map(&:join)
  puts a.sum { |t| t[:visit] } + 1, a.sum { |t| t[:bad] }
}
end
=end
timed do
  File.open("in.txt") { |file, guard = nil, threadc = 3, threads = [], len = 0|
    (b = file.each_with_index.map { |l, i| (len = l.strip.length) and l.strip.chars.each_with_index.map { |c, j| c == "#" ? nil : c == "^" ? ((guard = [i, j]) and 1) : 0 } }.reduce(&:+))
    dirs = {0 => [-1, 0], 1 => [0, 1], 2 => [1, 0], 3 => [0, -1]}
    gy, gx, dir, visited, locs = guard[0], guard[1], 0, 0, []
    while (y1, x1 = gy + dirs[dir][0], gx + dirs[dir][1]) and !(y1 < 0 or y1 >= len or x1 < 0 or x1 >= len)
      if b[(idx = y1 * len + x1)]
        (visited += (b[idx] = 1); locs.push([gy, gx, dir])) if b[idx] == 0
        gy, gx = y1, x1
      else
        dir = dir + 1 & 3
      end
    end
    threadlen = (locs.length + threadc) / threadc
    (0...threadc).each { |i|
      threads.push Thread.new { |local = 0|
        locs1 = locs.clone
        (i * threadlen...[(i + 1) * threadlen, locs.length].min).each { |id|
          gyy, gxx, dir1 = locs1[id]
          y, x, last, ed = gyy + dirs[dir1][0], gxx + dirs[dir1][1], 0, {}
          while (y2, x2 = gyy + dirs[dir1][0], gxx + dirs[dir1][1]) and !(y2 < 0 or y2 >= len or x2 < 0 or x2 >= len)
            if (y2 != y or x2 != x) and b[y2 * len + x2]
              gyy, gxx = y2, x2
            else
              dir1 = dir1 + 1 & 3
              k = (last << 16) + (gyy  << 8) + gxx
              (local += 1; break) if ed[k]
              last = (gyy << (ed[k] = 16)) + gxx
            end
          end
        }
        Thread.current[:bad] = local
      }
    }
    puts visited + 1, threads.map(&:join).sum { |t| t[:bad] }
  }
end

=begin
timed do
puts File.open("in.txt") { |f, g = nil, th = 1, td = [], len = 0| (b = f.each_with_index.map { |l, i| (len = l.strip.length) and l.strip.chars.each_with_index.map { |c, j| c == "#" ? nil : c == "^" ? ((g = [i, j]) and 1) : 0 } }.reduce(&:+)) and (0..th).each { |i, ds = {0 => [-1, 0], 1 => [0, 1], 2 => [1, 0], 3 => [0, -1]}| td.push Thread.new { |bad = 0, ok = 0| (i * len / th...[(i + 1) * len / th, len].min).each { |y| (0..len).each { |x, gy = g[0], gx = g[1], d = 0, edge = {}, last = 0| ((b1 = (gy == y && gx == x)) || true and (0..).each { (break if ((y1 = gy + ds[d][0]) < 0 || y1 >= len || (x1 = gx + ds[d][1]) < 0 || x1 >= len)) or ((b1 || y1 != y || x1 != x) && b[(idx = y1 * len + x1)]) ? ((ok += (b[idx] = 1)) if (gy, gx = y1, x1) && b1 && b[idx] == 0) : ((((d = d + 1 & 3) and ((bad += 1; break) if edge[(k = (last << 14) + (gy << 7) + gx)])) || true) and (edge[k] = true) and (last = (gy << 7) + gx)) }) if b[len * y + x] } } and (Thread.current[:bad], Thread.current[:ok] = bad, ok) } } and [(a = td).map(&:join).sum { |t| t[:ok] } + 1, a.sum { |t| t[:bad] }] }
end
=end
