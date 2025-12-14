DIRS = [[0, -1], [-1, 0], [0, 1], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]

grid = File.foreach("in.txt", chomp: true).map { |s| (["."] + s.chars + ["."]).map { |c| [c == "@" ? 1 : 0, 0] } }
grid = (a = [(0...grid[0].length).map { [0, 0] }]) + grid + a

(1...grid.length - 1).each { |y| (1...grid[0].length - 1).each { |x|
  DIRS.each { |dx, dy| grid[y + dy][x + dx][1] += 1 } if grid[y][x][0] == 1
} }

p (0..).reduce(0) { |s, _, marked = []|
  sum = (1...grid.length - 1).sum { |y| (1...grid[0].length - 1).sum { |x| grid[y][x][0] == 1 && grid[y][x][1] < 4 ? (marked.push([y, x]) and 1) : 0 } }
  p sum if s == 0
  marked.each { |y, x|
    grid[y][x][0] = 0
    DIRS.each { |dx, dy| grid[y + dy][x + dx][1] -= 1 }
  }
  s + sum == s ? (break s) : s + sum
}