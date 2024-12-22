require "../timer"

timed(10) {
puts File.open("in.txt") { |f, vals = [], bad_blocks = [], good_blocks = [], res = 0, res2 = 0, left = 0, i = 0|
  f.map(&:strip).map(&:chars).each.map { |l| l.map(&:to_i) }[0]
   .each_with_index { |j, k|
     k & 1 == 0 ? (good_blocks.insert(0, [(vals.length...vals.length + j), k >> 1])) : (bad_blocks.unshift(vals.length...vals.length + j) unless j == 0)
     (0...j).each { vals.push(k & 1 == 0 ? k >> 1 : -1) }
   }
  right = vals.length - 1
  while left < right
    if vals[left] == -1
      (0..).each { break true unless (vals[right] == -1) and (right -= 1)}
      vals[left], vals[right] = vals[right], -1
    end
    res += vals[(left += 1) - 1] * ((i += 1) - 1)
  end
  good_blocks.each { |range, idx, l = 0|
    (while (p = bad_blocks[l -= 1])
       next if p.begin >= range.begin or p.size < range.size
       (sz2 = (rng = p.end - (p.size - (sz = range.size))...p.end).size)
       bad_blocks.delete_at(l)
       bad_blocks.insert((a = bad_blocks.bsearch_index { |rng3| rng.begin > rng3.begin }) ? a : -1, rng) if sz2 != 0
       (p.begin...p.begin + sz).each { |k| res2 += k * idx }
       break true
     end) || (range.each { |k| res2 += k * idx })
  } and [res, res2]
}
}
puts File.open("in.txt"){|f,v=[],b=[],g=[],q=0,p=0,l=0,i=0|f.map{|z|z.strip.chars.map(&:to_i)}[0].each_with_index{|j,k|(k&1==0?(g.insert(0,[(v.length...v.length+j),k/2])):(b.unshift(v.length...v.length+j)if j!=0))&&(0...j).each{v.push(k&1==0?k/2:-1)}}&&(r=v.length-1)and(0..).each{(break if l>=r)or(((0..).each{break 1if !((v[r]==-1)&&(r-=1))}&&(v[l],v[r]=v[r],-1))if v[l]==-1)||1and q+=v[(l+=1)-1]*((i+=1)-1)}||1&&g.each{|h,c,l=0|((0..).each{|_,w=b[l-=1]|(break if !w)||(next if w.begin>=h.begin||w.size<h.size)||(n=w.end-(w.size-(v=h.size))...w.end)&&(b.delete_at(l))&&(b.insert((a=b.bsearch_index{|m|n.begin>m.begin})?a:-1,n)if n.size!=0)||1and(w.begin...w.begin+v).each{|k|p+=k*c}&&(break true)})||(h.each{|k|p+=k*c})}&&[q,p]}
