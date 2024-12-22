CODES, INPUTS, DIR, CACHE, P2I = [File.open("in.txt").map(&:strip)].freeze, ["789456123 0A", " ^a<v>"].map { |s| s.chars.each_with_index.map { |c, idx| [c, [idx / 3, idx % 3]] } }.reduce(&:+).filter { |a| a[0] != " " }.to_h.freeze, { "^" => [-1, 0],"v" => [1, 0], "<" => [0, -1], ">" => [0, 1] }.freeze, {}, proc { |c1, c2, i| i * 100000 + c1[0] * 1000 + c1[1] * 100 + c2[0] * 10 + c2[1] }

def expand_path(path, start, iter = start, c = iter == start ? "A" : "a")
  path.sum { |d| CACHE[(key = P2I.((a = INPUTS[c]), INPUTS[(c = d)], iter))] ? CACHE[key] : CACHE[key] =
      (possible = CACHE[(key = P2I.(a, (t = INPUTS[d]), iter == start ? -2 : -1))] ? CACHE[key] : CACHE[key] = (((dx = t[0] - a[0]) < 0 ? "^" : "v") * dx.abs + ((dy = t[1] - a[1]) < 0 ? "<" : ">") * dy.abs).chars.permutation.to_a.uniq.filter { |str|
          str.reduce(a + [true]) { |(y, x, f), e| (b = [y + DIR[e][0], x + DIR[e][1]]) + [f && b != (iter == start ? [3, 0] : [0, 0])] }[2]
        }.map { |str| str + ["a"] }
      iter == 0 ? possible[0].length : possible.map { |str| expand_path(str, start, iter - 1) }.min) }
end

puts CODES[0].reduce([0, 0]) { |a, code| [a[0] + expand_path(code.chars, 2) * (i = code.scan(/\d+/)[0].to_i), a[1] + expand_path(code.chars, 25) * i] }