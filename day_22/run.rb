puts (a = Array.new(1048576, max = 0)) && (seen = Array.new(1048576, (idx = 1) - 1)) && File.read("in.txt").split(/\n/).map(&:to_i).sum { |cu, last4 = 1048575|
  2000.times {
    i = (((i = (i = (cu & 262143) << 6 ^ cu) >> 5 ^ i) & 8191) << 11 ^ i)
    key = (key = (price = i % 10) - cu % 10) < 0 ? 16 | key.abs : key
    last4 = (((last4 & 32767) << 5) + key)
    cu = _1 < 3 || seen[last4] == idx ? i : (max = (a[last4] += price) > max ? a[last4] : max) && (seen[last4] = idx) && i
  } && (idx += 1) && cu
}, max