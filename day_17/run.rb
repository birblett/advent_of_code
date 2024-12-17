st = (str = File.read("in.txt").split(/\n|\r\n/).filter { |l| l.length != 0})[3][9..].split(",").map(&:to_i)
def ins_to_s(is, op, cb = [0, 1, 2, 3, "a", "b", "c", 7])
  case is
  when 0 then "a = a / (1 << #{cb[op]})"
  when 1 then "b = b ^ #{op}"
  when 2 then "b = #{cb[op]} & 7"
  when 3 then "return a, b, c"
  when 4 then "b = b ^ c"
  when 5 then "print \"\#{#{cb[op]} & 7},\" if d"
  when 6 then "b = a / (1 << #{cb[op]})"
  else "c = a / (1 << #{cb[op]})"
  end
end
i, instr, stack, p = -2, [], [[0, st.length - 1]], 0
instr.push ins_to_s(st[i], st[i + 1]) while (i += 2) < st.length
eval("def program(a, b, c, d=false)\n" + instr.reduce("") { |t, sh| t + "#{sh}\n" } + "end")
a, b, c = (str[0].scan(/\d+/) + str[1].scan(/\d+/) + str[2].scan(/\d+/)).map(&:to_i)
a, _, _ = program(a, b, c, true) while a > 0 or puts "\b "
((puts a; break) if p < 0
(0..7).each do |digit|
  _, b, _ = program((e = (a << 3) + digit), b, c)
  stack.push([e, p - 1]) if (b & 7 == st[p])
end) while (a, p = stack.pop)