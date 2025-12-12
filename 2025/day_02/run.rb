FACTORS_NONE = (1..10).map { |i| i.even? ? [i, [i / 2]] : [i, []] }.to_h
FACTORS = (1..10).map { |i| [i, (1..i / 2).filter { |i2| i % i2 == 0 }] }.to_h

def expand(base, mul, count)
  (0...count).reduce(base) { |summed, _| summed * mul + base }
end

def invalid(range, factors)
  [[range[0].length, (range[0].to_i..[10 ** range[0].length - 1, range[1].to_i].min)], [range[1].length, ([10 ** range[0].length, range[1].to_i].min..range[1].to_i)]].map { |digits, range, found = []|
    factors[digits].each { |d, current = (range.min / 10 ** (digits - d) - 1)|
      while (n = expand(current += 1, 10 ** d, digits / d - 1)) <= range.max
        found.push(n) if range.include?(n)
      end
    }
    found
  }.reduce(&:+)
end

p File.open("in.txt") { |f| f.read.split(",").map { _1.split("-") }.sum { |i| (invalid(i, FACTORS) | []).sum } }