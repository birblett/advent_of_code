def joltage(arr, n, left = -1)
  (0...n).reduce(0) { |sum, i|
    sum * 10 + (arr.length - (n - i)).downto(left + 1).reduce(0) { |max, j|
      arr[j] >= max ? arr[left = j] : max
    }
  }
end

puts File.foreach("in.txt", chomp: true).reduce([0, 0]) { |ans, line|
  arr = line.strip.chars.map(&:to_i)
  [ans[0] + joltage(arr, 2), ans[1] + joltage(arr, 12)]
}