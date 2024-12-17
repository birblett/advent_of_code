use std::fs::read_to_string;
use std::fmt;
use std::time::Instant;

#[derive(Debug)]
struct Range {
    start: i64,
    end: i64,
}

impl Range {

    fn size(&self) -> i64 {
        return self.end - self.start;
    }

    fn clone(&self) -> Range {
        return Range { start: self.start, end: self.end }
    }
}

impl fmt::Display for Range {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}...{}", self.start, self.end)
    }
}

fn main() {
    let start = Instant::now();
    if let Ok(lines) = read_to_string("in.txt") {
        let mut good: Vec<(Range, i64)> = Vec::new();
        let mut bad: Vec<Range> = Vec::new();
        let mut vals: Vec<i64> = Vec::new();
        lines.trim().chars().enumerate().for_each(|(i, c)| {
            let (l, idx) = ((c as i64) - 48, i as i64);
            if idx & 1 == 0 { good.insert(0, (Range { start: vals.len() as i64, end: vals.len() as i64 + l }, (idx >> 1) as i64)) }
            else if l != 0 { bad.insert(0, Range { start: vals.len() as i64, end: vals.len() as i64 + l }) }
            for _j in 0..l { vals.push(if idx & 1 == 0 { idx >> 1 } else { -1 }) }
        });
        let (mut left, mut right, mut i, mut res, mut res2) = (0, vals.len() - 1, 0, 0, 0);
        while left < right {
            if vals[left] == -1 {
                while vals[right] == -1 { right -= 1; }
                (vals[left], vals[right]) = (vals[right], -1);
            }
            (res, i, left) = (res + vals[left] * i, i + 1, left + 1);
        }
        good.iter().for_each(|(range, idx)| {
            let mut add = true;
            for l in (0..bad.len()).rev() {
                let (p, sz) = (bad[l].clone(), range.size());
                if p.start >= range.start || p.size() < sz { continue }
                let rng = Range { start: p.end - p.size() + sz, end: p.end };
                let sz2 = rng.size();
                bad.remove(l);
                if sz2 > 0 { bad.insert(bad.partition_point(|rng2| rng2.start > rng.start), rng) }
                for k in p.start..p.start + sz { res2 += k * idx }
                add = false;
                break;
            }
            if add { for k in range.start..range.end { res2 += k * idx } }
        });
        println!("{}\n{}", res, res2);
    }
    println!("elapsed: {:?}", start.elapsed());
}