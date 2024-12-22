puts (seq = {}) && File.read("in.txt").split(/\n/).map(&:to_i).sum { |cu, h = {}, last4 = 1048575|
  2000.times {
    i = ((i = ((i = (cu << 6 ^ cu) & 16777215) >> 5 ^ i) & 16777215) << 11 ^ i) & 16777215
    key = (key = (price = i % 10) - cu % 10) < 0 ? 16 | key.abs : key
    last4 = ((last4 << 5) + key) & 1048575
    cu = _1 < 3 || h[last4] ? i : (seq[last4] = seq.fetch(last4, 0) + price) && (h[last4] = i)
  } && cu
}, seq.max_by { _2 }[1]