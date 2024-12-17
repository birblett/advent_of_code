const std = @import("std");
const print = std.debug.print;
const data = @embedFile("in.txt");
const split = std.mem.split;

const Coord = struct { x: i32, y: i32,
    const Self = @This();
    pub fn add(self: Self, other: Coord) Coord { return Coord { .x = self.x + other.x, .y = self.y + other.y }; }
    pub fn sub(self: Self, other: Coord) Coord { return Coord { .x = self.x - other.x, .y = self.y - other.y }; }
    pub fn is_zero(self: Self) bool { return self.x == 0 and self.y == 0; }
    pub fn in_bounds(self: Self, max: i32) bool { return self.x < max and self.x >= 0 and self.y < max and self.y >= 0; }
};
fn crd(x: i32, y: i32) Coord {
    return Coord { .x = x, .y = y };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var frequencies = std.AutoHashMap(i32, *std.ArrayList(Coord)).init(alloc);
    var antinodes1 = std.AutoHashMap(Coord, bool).init(alloc);
    var antinodes2 = std.AutoHashMap(Coord, bool).init(alloc);
    var arrays: [1000]std.ArrayList(Coord) = undefined;
    var idx: usize = 0;
    defer {
        frequencies.clearAndFree();
        antinodes1.clearAndFree();
        antinodes2.clearAndFree();
    }
    var splits = std.mem.splitAny(u8, data, "\n");
    var size: i32 = 0;
    while (splits.next()) |line| {
        for (0.., line) |j, k| {
            if (k != 46 and k != 10 and k != 13) {
                if (!frequencies.contains(k)) {
                    arrays[idx] = std.ArrayList(Coord).init(alloc);
                    try frequencies.put(k, &arrays[idx]);
                    idx += 1;
                }
                try frequencies.get(k).?.append(crd(@intCast(j), size));
            }
        }
        size += 1;
    }
    var it = frequencies.valueIterator();
    var sum1: i32 = 0;
    var sum2: i32 = 0;
    while (it.next()) |freqs| {
        const len = freqs.*.items.len;
        for (0..len) |i| {
            const coord = freqs.*.items[i];
            for(i + 1..len) |j| {
                for(0..2) |r| {
                    var iter: i32 = 0;
                    const diff = freqs.*.items[j].sub(coord);
                    if (diff.is_zero()) break;
                    var coord1 = if (r == 1) coord else coord.add(diff);
                    while (coord1.in_bounds(size - 1)) {
                        if (iter == 1) {
                            if (antinodes1.get(coord1) == null) sum1 += 1;
                            try antinodes1.put(coord1, true);
                        }
                        if (antinodes2.get(coord1) == null) sum2 += 1;
                        try antinodes2.put(coord1, true);
                        coord1 = if (r == 1) coord1.sub(diff) else coord1.add(diff);
                        iter += 1;
                    }
                }
            }
        }
    }
    print("{d} {d}\n", .{sum1, sum2});
}