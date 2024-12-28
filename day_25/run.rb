keys, locks = File.read("in.txt").split("\n\n")
                  .map { _1.split("\n").map(&:chars).transpose }
                  .reduce([[], []]) { |(k, l), q| (q[0][0] == "." ? k : l).push(q.each_with_index.sum { |arr, i| arr.count("#") << (i << 2) }) && [k, l] }
puts "#{locks.sum { |lock| keys.sum { (lock + _1) & 559240 > 0 ? 0 : 1 } }}"