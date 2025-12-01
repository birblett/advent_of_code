File.open("in.txt", "r") { |f, pos = 50, c1 = 0, c2 = 0|
  f.map { |l| [l[1..].to_i, (l.start_with?(/L/) ? :- : :+)] }.each { |i, op, hpart = i.truncate(-2), tpart = (i - hpart)|
    c2 += hpart / 100
    oldpos = pos
    pos = pos.send(op, tpart)
    if pos > 99
      pos = pos - 100
      (c2 += 1) unless oldpos == 0
    elsif pos < 0
      pos = 100 + pos
      (c2 += 1) unless oldpos == 0
    elsif pos == 0
      c2 += 1
    end
    c1 += 1 if pos == 0
  }
  p c1, c2
}