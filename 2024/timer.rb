def timed(tests=1, throwout: 0, &block)
  total = 0
  (tests + throwout).times { |i|
    t = Time.now
    block.call
    t1 = Time.now
    puts "test #{i - throwout} finished in #{t1 - t}s" if throwout <= i
    total += t1 - t if throwout <= i
  }
  puts("#{tests} tests took #{total / [1, tests].max}s on avg")
end