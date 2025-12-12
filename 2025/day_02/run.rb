FACTORS_NONE = (1..10).map { |i| i.even? ? [i, [i / 2]] : [i, []] }.to_h
FACTORS = (1..10).map { |i| [i, (1..i / 2).filter { |i2| i % i2 == 0 }] }.to_h

def expand(base, mul, count) = (0...count).reduce(base) { |summed, _| summed * mul + base }

def invalid(range, factors)
  lhs = [range[0].length, (range[0].to_i..[10 ** range[0].length - 1, range[1].to_i].min)]
  rhs = [range[1].length, ([10 ** range[0].length, range[1].to_i].min..range[1].to_i)]
  [lhs, rhs].map { |digits, rng, found = []|
    factors[digits].each { |d, current = (rng.min / 10 ** (digits - d) - 1), n|
      (found.push(n) if rng.include?(n)) while (n = expand(current += 1, 10 ** d, digits / d - 1)) <= rng.max
    }
    found
  }.reduce(&:+)
end

File.open("in.txt") { |f|
  ranges = f.read.split(",").map { _1.split("-") }
  p ranges.sum { |i| (invalid(i, FACTORS_NONE) | []).sum }
  p ranges.sum { |i| (invalid(i, FACTORS) | []).sum }
}