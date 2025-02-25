imap, idx, max = {}, -1, 0
graph = File.open("in.txt").map(&:strip).map { _1.split("-") }.reduce({}) { |hash, (k, v)|
  i, j = imap[k] ? imap[k] : (imap[idx += 1] = k; imap[k] = idx), imap[v] ? imap[v] : (imap[idx += 1] = v; imap[v] = idx)
  ((hash[i] ? hash[i] : (hash[i] = {}))[j] = true) && ((hash[j] ? hash[j] : (hash[j] = {}))[i] = true) && hash
}
puts (keys = graph.keys).reduce({}) { |mset, k, set = {k => true}|
  keys.each { |nxt| set[nxt] = true unless set.any? { |i, _| !graph[nxt][i] } }
  set.length > max ? (max = set.length) && set : mset
}.keys.map { |k| imap[k] }.sort.join(",")