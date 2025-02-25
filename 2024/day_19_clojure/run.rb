(max = 1) && (patterns, towels = (s = File.read("in.txt").split(/\n\n/))[0].split(/, /).map{(max = [_1.length, max].max) && [_1, true]}.to_h, s[1].split(/\n/))
puts towels.reduce([0, 0]) { |res, towel|
  (table = Array.new(towel.length + 1, 0))[0] = 1
  (towel.length).times { |i| ([towel.length - i, max].min).times { |j| table[i + j + 1] += table[i] if patterns[towel[i..i + j]] } }
  [res[0] + (table[-1] > 0 ? 1 : 0), res[1] + table[-1]]
}