puts (board = File.read("in.txt").split.map { |line| line.chars.map(&:ord) }).each_with_index.reduce([0, 0, {}]) { |arr, (line, x), registry = {}|
  line.each_with_index { |c, y, size = line.length, segments = 0, corners = 0|
    stack = [x + y * size]
    (area = (0..).each { |d|
      break d if !(t = stack.pop) or arr[2][t]
      y, xx, hz_n, vt_n, registry[t] = t / size, t % size, [], 0, (arr[2][t] = true)
      [[xx, y + 1], [xx, y - 1], [xx + 1, y], [xx - 1, y]].each { |x1, y1|
        b1 = x1 >= 0 && x1 < size && y1 >= 0 && y1 < size && board[x1][y1] == c
        (x1 == xx ? hz_n.push(y1) : vt_n += (hz_n.each { |y2| corners += 1 if board[x1][y2] != c } and 1)) if b1
        b1 ? ((stack.push(x1 + y1 * size); registry[x1 + y1 * size] = true) unless registry[x1 + y1 * size]) : (segments += 1)
      }
      (t_n = hz_n.length + vt_n) <= 1 ? corners += 2 - t_n << 1 : (corners += 1 if hz_n.length == 1 and vt_n == 1)
    }) and (arr[0], arr[1] = arr[0] + segments * area, arr[1] + corners * area)
  } and arr
}.shift(2)