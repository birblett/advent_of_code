# new
puts File.open("in.txt") { |file|
  lines, graph = [], {}
  file.each { |line|
    if (x,y = line.strip.split("|"))[1]
      graph[(x = x.to_i)] ? graph[x][y.to_i] = true : graph[x] = { y.to_i => true }
    elsif x
      lines.push(x.split(",").map(&:to_i))
    end
  }
  lines.reduce([0, 0]) { |arr, line|
    s, good = [], true
    while line.length > 0
      bad = []
      rm = line.delete_at(0)
      s.each_with_index { |v, i| bad.push(i) if graph[rm] and graph[rm][v] }
      if bad.length != 0
        good = false
        bad.reverse_each { |i| line.push(s.delete_at(i)) }
      end
      s.push(rm)
    end
    [arr[0] + (good ? s[s.length / 2] : 0), arr[1] + (!good ? s[s.length / 2] : 0)]
  }
}

# new (one line)
puts File.open("in.txt") { |file, lines = [], graph = {}| file.each { |line| (x,y = line.strip.split("|"))[1] ? (graph[(x = x.to_i)] ? (graph[x][y.to_i] = true) : (graph[x] = { y.to_i => true })) : (lines.push(x.split(",").map(&:to_i)) if x) } and lines.reduce([0, 0]) { |arr, line, s = [], good = true| (0..).each { |_, bad = [], rm = line.delete_at(0)| s.each_with_index { |v, i| bad.push(i) if graph[rm] and graph[rm][v] } and bad.length == 0 ? s.push(rm) : ((good = false) or bad.reverse_each { |i| line.push(s.delete_at(i)) } and s.push(rm)) and (break if line.length == 0) } or [arr[0] + (good ? s[s.length / 2] : 0), arr[1] + (!good ? s[s.length / 2] : 0)] } }