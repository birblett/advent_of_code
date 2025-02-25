start, out = File.read("in.txt").split(/\n\n/).map { _1.split(/\n/) }
start, k = start.map { [(a = _1.split(": "))[0],a[1].to_i] }.to_h, nil
final, regs, bad, sregs, is, queue, is_done = "z#{start.keys.sort[-1].scan(/\d+/)[0].to_i + 1}", {}, [], {"x00" => true, "y00" => true}, {}, start.keys.sort, {}
out.each { |s|
  op1, op, op2 = (str, dst = s.split(" -> "))[0].split(" ")
  regs[dst] ? (regs[dst][0] = op) && (regs[dst][1] = [op1, op2]) : regs[dst] = [op, [op1, op2], []]
  [op1, op2].each { (is[_1] = is.fetch(_1, [])).push([str, dst]) && (regs[_1] ? regs[_1][2].push(dst) : (regs[_1] = [nil, [], [dst]])) }
}
regs.each { |k, v|
  v[2].empty? ? (k == final ? (bad.push(k) if v[0] != "OR") :
    v[0] != "XOR" || v[1].any? { start[_1] && _1.scan(/\d+/) != k.scan(/\d+/)} ? bad.push(k) : v[1].each { |p|
      regs[p][1].any? { start[_1] } ?  (bad.push(p) if regs[p][0] != "XOR" unless regs[p][1].any? { sregs[_1] }) :
        (bad.push(p) if regs[p][0] != "OR" unless start[p]) }) : (v[1].each { bad.push(_1) if regs[_1][0] != "AND" } if v[0] == "OR")
}
(is[k].each { |instr, dest|
  next unless ((op1, op, op2) = instr.split(" ")) and start[op1] and start[op2]
  is_done[instr + dest] ? next : is_done[instr + dest] = true
  start[queue.push(dest) && dest] = start[op1].method(op == "AND" ? :& : op == "OR" ? :| : :^).call(start[op2])
} if is[k]) while (k = queue.shift)
puts start.keys.sort.reduce(0) { |s, k2| (s += start[k2] << (k2.scan /\d+/)[0].to_i if k2.start_with? "z") || s }, bad.sort.join(",")