a = (h = File.read("in.txt").split("\n\n"))[0].split(/\n/).map { _1.split("|").map(&:to_i) }.reduce({}) { |h, (k, v)| (h[k] = h.fetch(k,[]) + [v]) && h }
require('tsort') && Hash.include(TSort).alias_method(:tsort_each_node, :each_key)
Hash.define_method(:tsort_each_child) { |node, &block| self[node].each(&block) if self[node]}
puts h[1].split(/\n/).map { _1.split(/,/).map(&:to_i).map { |i| [i, true] }.to_h }.reduce([0, 0]) { |(s1, s2), seq, k = seq.keys|
  k == (s = k.map { |s| [s, a[s] ? a[s].filter {seq[_1]} : []] }.to_h.tsort.reverse) ? [s1 + s[s.size / 2], s2] : [s1, s2 + s[s.size / 2]]
}