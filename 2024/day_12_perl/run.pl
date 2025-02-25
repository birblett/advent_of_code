#!/usr/bin/perl
use warnings;
use integer;
open(my $in, '<', "in.txt");
(@array, %seen) = ((), ());
while (defined(my $line = <$in> )) {
    chomp $line;
    push(@array, [unpack("W*", $line)]);
}
$size = @array;
($sum1, $sum2) = (0, 0);
@dirs = (1, -1, $size, -$size);
for my $i (0 .. $size - 1) {
    for my $j (0 .. $size - 1) {
        (my $print, my $corners, my $segments, my $area) = (0, 0, 0, 0);
        my @stack = ($i * $size + $j + 1);
        while (my $var = pop(@stack)) {
            next if $seen{$var -= 1};
            $area += ($seen{$var} = $print = 1);
            (my $ch, $vtn) = ($array[$y = $var / $size][$x = $var % $size], 0);
            my @hzn = ();
            foreach (@dirs) {
                (my $yy, my $xx) = ($y + (my $dy = $_ / $size), $x + (my $dx = $_ % $size));
                if ($yy >= 0 and $yy < $size and $xx >= 0 and $xx < $size and $array[$yy][$xx] == $ch) {
                    push(@stack, $yy * $size + $xx + 1);
                    $dy == 0 ? (push(@hzn, $xx)) : ($vtn += 1);
                    if ($dy != 0) {
                        $corners += $array[$yy][$_] != $ch foreach @hzn;
                    }
                } else {
                    $segments += 1;
                }
            }
            my $tn = (my $len = @hzn) + $vtn;
            $tn <= 1 ? ($corners += 2 - $tn << 1) : ($corners += ($len and $len == 1 and $vtn == 1));
        }
        ($sum1, $sum2) = ($sum1 + $area * $segments, $sum2 + $area * $corners);
    }
}
print $sum1, "\n", $sum2, "\n";