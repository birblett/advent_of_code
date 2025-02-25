function splits(str, delim)
    return map((s) -> string(s), split(str, delim))
end
start, out = splits(read("in.txt", String), "\n\n")
start = Dict(map((s) -> [splits(s, ": ")[1], parse(Int, split(s, ": ")[2])], split(start, "\n")))
out = splits(string(out), "\n")
regs, bad_nodes, node_type, is, queue, is_done, iter = Dict(), Dict(), Dict(), Dict(), sort(collect(keys(start))), Dict(), -1
for s in out
    str, dst = splits(s, " -> ")
    op1, op, op2 = splits(str, " ")
    regs[dst] = dst in keys(regs) ? [op, [op1, op2], regs[dst][3]] : [op, [op1, op2], []]
    for k in [op1, op2]
        (k in keys(is)) || (is[k] = [])
        push!(is[k], [str, dst])
        k in keys(regs) ? push!(regs[k][3], dst) : (regs[k] = [0, [], [dst]])
    end
end
for (k, v) in is
    is[k] = sort(v, by = (x) -> x[1][5])
end
while (k = popat!(queue, 1, false)) != false
    if k in keys(is)
        for (instr, dest) in is[k]
            op1, op, op2 = splits(instr, " ")
            if !(instr * dest in keys(is_done)) && (op1 in keys(start)) && (op2 in keys(start)) && (is_done[instr * dest] = true)
                node_type[dest] = endswith(op1, "00") ? "IGNORE" : op
                global iter = (dest == "z01" || iter >= 0) ? iter + 1 : -1
                (((startswith(op1, "x") || startswith(op2, "x")) && startswith(dest, "z") && dest != "z00") || iter >= 0 &&
                ((iter % 3 == 0) ? (!startswith(dest, "z")) : (dest != "z45" && startswith(dest, "z")))) && (bad_nodes[dest] = true)
                for k in [op1, op2]
                    (temp = get(node_type, k, "")) != "IGNORE" && ((temp == "AND") ⊻ (op == "OR")) && (bad_nodes[k] = true)
                end
                push!(queue, dest)
                start[dest] = op == "AND" ? (start[op1] & start[op2]) : op == "OR" ? (start[op1] | start[op2]) : (start[op1] ⊻ start[op2])
            end
        end
    end
end
println(reduce((s, k) -> startswith(k, "z") && ((m = match(r"\d+", k)) == nothing ? s : s + (start[k] << parse(Int, m.match))), sort(collect(keys(start))), init = 0))
println(join(sort(collect(keys(bad_nodes))), ","))