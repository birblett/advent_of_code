import std.stdio;
import std.conv;

void main() {
    auto f = File("in.txt");
    int[] map = new int[](1048576), seen = new int[](1048576);
    int i, price, idx = 1;
    long sum, max;
    foreach (line; f.byLine) {
        auto curr = parse!int(line);
        auto last4 = 1048575;
        foreach (j; 0..2000) {
            i = (((i = (i = (curr & 262143) << 6 ^ curr) >> 5 ^ i) & 8191) << 11 ^ i);
            last4 = (((last4 & 32767) << 5) + (price = i % 10) - curr % 10 + 9);
            if (j > 2 && seen[last4] != idx) {
                max = (map[last4] += price) > max ? map[last4] : max;
                seen[last4] = idx;
            }
            curr = i;
        }
        idx++;
        sum += curr;
    }
    writeln(sum);
    writeln(max);
    f.close();
}