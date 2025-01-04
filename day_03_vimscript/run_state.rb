puts File.open("in.txt") { |file, machine = { s1: 0, s2: 0, enabled: true }, st = nil, sum = 0, p2 = ARGV.include?("2")|
  file.each_byte { |b|
    (b == 109 && !st && machine[:enabled]) ? (st = :MULM)
  : (b == 117 && st == :MULM) ? (st = :MULU)
  : (b == 108 && st == :MULU) ? (st = :MULL)
  : (b == 40 && st == :MULL) ? (st = :MULP)
  : ((48..57).include?(b) && (st == :MULP || st == :NUM1)) ? ((machine[:s1] = machine[:s1] * 10 + (b - 48)) && (st = :NUM1))
  : (b == 44 && st == :NUM1) ? (st = :MULC)
  : ((48..57).include?(b) && (st == :MULC || st == :NUM2)) ? ((machine[:s2] = machine[:s2] * 10 + (b - 48)) && (st = :NUM2))
  : (b == 41 && st == :NUM2) ? ((sum += machine[:s1] * machine[:s2]) && (machine[:s1] = (machine[:s2] = 0)) && (st = nil))
  : (b == 100 && !st && p2) ? (st = :DOD)
  : (b == 111 && st == :DOD) ? (st = :DOO)
  : (st == :DOO) ? (b == 110 ? (st = :DONN) : (b == 40 ? (st = :DOP) : (st = nil)))
  : (b == 41 && st == :DOP) ? ((machine[:enabled] = true) && (st = nil))
  : (b == 39 && st == :DONN) ? (st = :DONQ)
  : (b == 116 && st == :DONQ) ? (st = :DONT)
  : (b == 40 && st == :DONT) ? (st = :DONP)
  : (b == 41 && st == :DONP) ? ((machine[:enabled] = false) && (st = nil))
  : (machine[:s1] = (machine[:s2] = 0)) && (st = nil)
  } and sum
}