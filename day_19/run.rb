s, p, original, prev = File.read("in.txt").split(/\r\n\r\n|\n\n/), nil, nil, nil
towels, valid, pcache = s[0].split(", "), (stack = s[1].split(/\r\n|\n/).map { |x| x.strip }.map { |st| [st, st, []] }).map { |p| [p[0], 0] }.to_h, {}
((pcache[p] && valid[original] += pcache[p]) ? prev.each { |pr| pcache[pr] = pcache.fetch(pr, 0) + pcache[p] } :
  (p.length == 0 && valid[original] += 1) ? (prev.each { |pr| pcache[pr] = pcache.fetch(pr, 0) + 1 }) :
    (pcache[p] = 0 unless towels.sum { |t| p.start_with?(t) ? (stack.push([p[t.length..], original, prev + [p]]) and 1) : 0 } > 0)) while (p, original, prev = stack.pop)
puts valid.reduce([0, 0]) { |(p1, p2), (_, v)| [p1 + (v > 0 ? 1 : 0), p2 + v] }

puts (p,o,k,x,y,z=0,0,0,(s=File.read("in.txt").split(/\r\n\r\n|\n\n/))[0].scan(/[a-z]+/),(q=s[1].scan(/[a-z]+/).map{|x|x.strip}.map{|w|[w,w,[]]}).map{|a|[a[0],0]}.to_h,{}) && (((z[p]&&y[o]+=z[p])?k.each{|h|z[h]=z.fetch(h,0)+z[p]}:(p.empty?&&y[o]+=1)?k.each{|h|z[h]=z.fetch(h,0)+1}:(z[p]=0if x.sum{|t|p.start_with?(t)?(q.push([p[t.length..],o,k+[p]])&&1):0}==0))while(p,o,k=q.pop))||y.reduce([0,0]){|(c,d),(_,v)|[c+(v>0?1:0),d+v]}