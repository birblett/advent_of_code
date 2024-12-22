a = (h = File.read("in.txt").split("\n\n"))[0].split(/\n/).map { |s| s.split("|").map(&:to_i) }.reduce({}) { |h, (k, v)| (h[k] = h.fetch(k,[]) + [v]) && h }
require('tsort') && Hash.include(TSort).alias_method(:tsort_each_node, :each_key)
Hash.define_method(:tsort_each_child) { |node, &block| self[node].each(&block) if self[node]}
puts h[1].split(/\n/).map { |s| s.split(/,/).map(&:to_i).map { |i| [i, true] }.to_h }.reduce([0, 0]) { |(s1, s2), seq, k = seq.keys|
  k == (s = k.map { |s| [s, a[s] ? a[s].filter {seq[_1]} : []] }.to_h.tsort.reverse) ? [s1 + s[s.size / 2], s2] : [s1, s2 + s[s.size / 2]]
}

# new (one line)
puts File.open("in.txt") { |file, lines = [], graph = {}| file.each { |line| (x,y = line.strip.split("|"))[1] ? (graph[(x = x.to_i)] ? (graph[x][y.to_i] = true) : (graph[x] = { y.to_i => true })) : (lines.push(x.split(",").map(&:to_i)) if x) } and lines.reduce([0, 0]) { |arr, line, s = [], good = true| (0..).each { |_, bad = [], rm = line.delete_at(0)| s.each_with_index { |v, i| bad.push(i) if graph[rm] and graph[rm][v] } and bad.length == 0 ? s.push(rm) : ((good = false) or bad.reverse_each { |i| line.push(s.delete_at(i)) } and s.push(rm)) and (break if line.length == 0) } or [arr[0] + (good ? s[s.length / 2] : 0), arr[1] + (!good ? s[s.length / 2] : 0)] } }