puts File.open("in.txt") { |file, dim = 0, frq_reg = {}, antinode = {}, antinodes = {}|
  file.each_with_index { |line, y| dim = line.strip.length; line.strip.split("").each_with_index.map { |c, x| c == "." ? 0 : (frq_reg[c.ord] = frq_reg.fetch(c.ord, []) + [[y, x]]) and c.ord } }
  range = ((sum1 = sum2 = 0)...dim)
  frq_reg.each { |_, v|
    v.each_with_index { |(y, x), i|
      (i + 1...v.length).each { |j|
        (0..1).each { |r, diffy = (v[j][0] - y), diffx = (v[j][1] - x), iter = -1|
          r == 0 ? (y1, x1 = y, x) : (y1, x1 = v[j][0], v[j][1])
          ((sum1 += 1 unless antinode[[y1, x1]]) and (antinode[[y1, x1]] = true) if iter == 1
          (sum2 += 1 unless antinodes[[y1, x1]]) and (antinodes[[y1, x1]] = true)
          (r == 0 ? (y1, x1 = y1 - diffy, x1 - diffx) : (y1, x1 = y1 + diffy, x1 + diffx))) while range.include?(y1) and range.include?(x1) and (iter += 1) + 1
        }
      }
    }
  } && [sum1, sum2]
}