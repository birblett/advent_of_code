File.open("in.txt") { |file|
  frq_reg = {}
  dim = 0
  file.each_with_index { |line, y| dim = line.strip.length; line.strip.split("").each_with_index.map { |c, x| c == "." ? 0 : (frq_reg[c.ord] = frq_reg.fetch(c.ord, []) + [[y, x]]) and c.ord } }
  antinode = {}
  antinodes = {}
  range = ((sum1 = sum2 = 0)...dim)
  frq_reg.each { |k, v|
    v.each_with_index { |(y, x), i|
      puts "#{x} #{y}"
      (i + 1...v.length).each { |j|
        (0..1).each { |r, diffy = (v[j][0] - y), diffx = (v[j][1] - x), iter = -1|
          r == 0 ? (y1, x1 = y, x) : (y1, x1 = v[j][0], v[j][1])
          while range.include?(y1) and range.include?(x1) and (iter += 1) + 1
            (sum1 += 1 unless antinode[[y1, x1]]) and (antinode[[y1, x1]] = true) if iter == 1
            (sum2 += 1 unless antinodes[[y1, x1]]) and (antinodes[[y1, x1]] = true)
            (r == 0 ? (y1, x1 = y1 - diffy, x1 - diffx) : (y1, x1 = y1 + diffy, x1 + diffx))
          end
        }
      }
    }
  }
  puts sum1, sum2
}

puts File.open("in.txt") { |file, frq_reg = {}, dim = 0, antinode = {}, antinodes = {}| file.each_with_index { |line, y| dim = line.strip.length; line.strip.split("").each_with_index { |c, x| c == "." ? 0 : (frq_reg[c.ord] = frq_reg.fetch(c.ord, []) + [[y, x]]) } } and (range = ((sum1 = sum2 = 0)...dim)) and frq_reg.each { |_k, v| v.each_with_index { |(y, x), i| (i + 1...v.length).each { |j| 2.times { |r, diffy = (v[j][0] - y), diffx = (v[j][1] - x), iter = -1| ((r == 0 ? (y1, x1 = y, x) : (y1, x1 = v[j][0], v[j][1])) and 0..).each { (break unless (range.include?(y1) and range.include?(x1) and (iter += 1) + 1)) or (((sum1 += 1 unless antinode[[y1, x1]]) && (antinode[[y1, x1]] = true) if iter == 1) or true) and ((sum2 += 1 unless antinodes[[y1, x1]]) && (antinodes[[y1, x1]] = true) or true) and (r == 0 ? (y1, x1 = y1 - diffy, x1 - diffx) : (y1, x1 = y1 + diffy, x1 + diffx)) } } } } } and [sum1, sum2] }