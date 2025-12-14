ranges, ids = File.foreach("in.txt", chomp: true).reduce([[], []]) { |a, line|
  [a[0] + (line["-"] ? [(r = line.split("-").map(&:to_i))[0]..r[1]] : []), a[1] + (line.match?(/^\d+$/) ? [line.to_i] : [])]
}

p ids.sum { |n| ranges.any? { |r| r.include? n } ? 1 : 0 }

p ranges.sort_by(&:min).reduce([]) { |rngs, curr|
  (last = rngs.last) && curr.min <= last.end ?
    (rngs[..-2] + [(last.min..[last.end, curr.end].max)]) :
    (rngs + [curr])
}.sum { |r| r.max - r.min + 1 }