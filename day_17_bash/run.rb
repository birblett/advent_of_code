st = (str = File.read("in.txt").split(/\n|\r\n/).filter { |l| l.length != 0})[3][9..].split(",").map(&:to_i)
def ins_to_s(is, op, cb = [0, 1, 2, 3, "a", "b", "c", 7]) =
  ["a = a / (1 << #{cb[op]})", "b = b ^ #{op}", "b = #{cb[op]} & 7", "return a, b, c", "b = b ^ c", "print \"\#{#{cb[op]} & 7},\" if d",
   "b = a / (1 << #{cb[op]})", "c = a / (1 << #{cb[op]})"][is]
i, instr, stack, p = -2, [], [[0, st.length - 1]], 0
instr.push ins_to_s(st[i], st[i + 1]) while (i += 2) < st.length
eval("def program(a, b, c, d=false)\n" + instr.reduce("") { |t, sh| t + "#{sh}\n" } + "end")
a, b, c = (str[0].scan(/\d+/) + str[1].scan(/\d+/) + str[2].scan(/\d+/)).map(&:to_i)
a = program(a, b, c, true)[0] while a > 0 or puts "\b "
((puts a; break) if p < 0
(0..7).reverse_each { |digit, e| stack.push([e, p - 1]) if (b = program((e = (a << 3) + digit), b, c)[1] & 7 == st[p]) }) while (a, p = stack.pop)