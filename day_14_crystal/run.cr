width, height, quads, bots = 101, 103, [0, 0, 0, 0], File.read_lines("in.txt").map { |line| line.scan(/-?\d+/).map { |match| match[0].to_i } }
w, h, hw, hh = width - 1, height - 1, width // 2, height // 2
puts (1..).each { |i|
    set = Set(Int32).new
    bots.each { |bot|
        set.add((bot[0] = (bot[0] + bot[2]) % width) + (bot[1] = (bot[1] + bot[3]) % height) * width)
        quads[(bot[0] < hw ? 1 : 0) + 2 * (bot[1] < hh ? 1 : 0)] += 1 if i == 100 unless bot[0] == hw || bot[1] == hh
    }
    puts quads.reduce(1) { |i, j| i * j } if i == 100
    break i if set.size == bots.size
}