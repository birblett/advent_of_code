File.open("in.txt") { |file|
  bot = nil
  board = []
  bap = false
  instr = []
  file.each_with_index { |line, i|
    line.strip.chars.each_with_index { |c, j|
      if !bap and ">^<v".include? c
        bap = true
      end
      if bap
        instr.push(c)
      else
        board[i] = [] unless board[i]
        board[i][j] = c
        bot = [i, j] if c == "@"
      end
    }
  }
  dirs = {"<" => [0, -1], "^" => [-1, 0], "v" => [1, 0], ">" => [0, 1]}
  instr.each { |c|
    dy, dx = dirs[c]
    tmp = [bot[0] + dy, bot[1] + dx]
    move = true
    registermove = []
    while board[tmp[0]][tmp[1]] != "."
      if board[tmp[0]][tmp[1]] == "#"
        move = false
        break
      end
      if board[tmp[0]][tmp[1]] == "O"
        registermove.push([tmp[0], tmp[1]])
      end
      tmp = [tmp[0] + dy, tmp[1] + dx]
    end
    if move
      while (p = registermove.pop)
        board[p[0] + dy][p[1] + dx] = "O"
      end
      board[bot[0]][bot[1]] = "."
      bot[0] += dy
      bot[1] += dx
      board[bot[0]][bot[1]] = "@"
    end
  }
  s = 0
  board.each_with_index { |line, i|
    line.each_with_index { |c, j|
      print c
      s += 100 * i + j if c == "O"
    }
    puts
  }
  puts "#{s}"
}

File.open("in.txt") { |file|
  bot = nil
  board = []
  bap = false
  instr = []
  file.each_with_index { |line, i|
    line.strip.chars.each_with_index { |c, j|
      if !bap and ">^<v".include? c
        bap = true
      end
      if bap
        instr.push(c)
      else
        board[i] = [] unless board[i]
        c1 = ""
        c2 = ""
        if c == "#"
          c1, c2 = "#", "#"
        elsif c == "."
          c1, c2 = ".", "."
        elsif c == "O"
          c1, c2 = "[", "]"
        elsif c == "@"
          c1, c2 = "@", "."
          bot = [i, j * 2]
        end
        board[i][j * 2] = c1
        board[i][j * 2 + 1] = c2
      end
    }
  }
  dirs = {"<" => [0, -1], "^" => [-1, 0], "v" => [1, 0], ">" => [0, 1]}
  instr.each { |c, move = true|
    dy, dx = dirs[c]
    registermove = []
    moving = [[[bot[0] + dy, bot[1] + dx]]]
    while (tmp = moving.pop) and (t = [])
      tmp.each { |y, x|
        next if board[y][x] == "."
        (break (move = false)) if board[y][x] == "#"
        if board[y][x] == "["
          registermove.push([y, x, "["], [y, x + 1, "]"])
          t.push([y + dy, x + dx * 2])
          t.push([y + dy, x + 1 + dx * 2]) if dy != 0
        elsif board[y][x] == "]"
          registermove.push([y, x, "]"], [y, x - 1, "["])
          t.push([y + dy, x + dx * 2])
          t.push([y + dy, x - 1 + dx * 2]) if dy != 0
        end
      }
      moving.push(t) unless t.length == 0
      break unless move
    end
    if move
      while (p = registermove.pop)
        board[p[0]][p[1]] = "."
        board[p[0] + dy][p[1] + dx] = p[2]
      end
      board[bot[0]][bot[1]] = "."
      bot[0] += dy
      bot[1] += dx
      board[bot[0]][bot[1]] = "@"
    end
  }
  s = 0
  board.each_with_index { |line, i|
    line.each_with_index { |c, j|
      print c
      s += 100 * i + j if c == "["
    }
    puts
  }
  puts "#{s}"
}