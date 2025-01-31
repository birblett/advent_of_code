puts File.open("in.txt") { |f, vals = [], bad_blocks = [], good_blocks = [], res = 0, res2 = 0, left = 0, i = 0, right|
  f.map(&:strip).map(&:chars).each.map { |l| l.map(&:to_i) }[0].each_with_index { |j, k|
     k & 1 == 0 ? (good_blocks.insert(0, [(vals.length...vals.length + j), k >> 1])) : (bad_blocks.unshift(vals.length...vals.length + j) unless j == 0)
     (0...j).each { vals.push(k & 1 == 0 ? k >> 1 : -1) }
  }
  (if vals[left] == -1
    (0..).each { break right unless (vals[right] == -1) and (right -= 1)}
    vals[left], vals[right] = vals[right], -1
  end
  res += vals[(left += 1) - 1] * ((i += 1) - 1)) while left < (right ||= vals.length - 1)
  good_blocks.each { |range, idx, l = 0|
    (while (p = bad_blocks[l -= 1])
       ((sz2 = (rng = p.end - (p.size - (sz = range.size))...p.end).size)
       bad_blocks.delete_at(l)
       bad_blocks.insert((a = bad_blocks.bsearch_index { |rng3| rng.begin > rng3.begin }) ? a : -1, rng) if sz2 != 0
       (p.begin...p.begin + sz).each { |k| res2 += k * idx }
       break true) unless p.begin >= range.begin or p.size < range.size
     end) || (range.each { |k| res2 += k * idx })
  } && [res, res2]
}