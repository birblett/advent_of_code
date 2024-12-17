package main
import ("bufio"; "fmt"; "os"; "regexp"; "strconv")

func Map[T, V any](ts []T, fn func(T) V) []V {
    result := make([]V, len(ts))
    for i, t := range ts { result[i] = fn(t) }
    return result
}

func validate(match []int, bad int) bool {
    s, diff, st, bl := map[int]bool{}, 1, 1, true
    if bad == 0 {
        st = 2
    }
    for i := st; i < len(match); i++ {
        if i == bad {
            diff = 2
            continue
        }
        s[match[i] - match[i - diff]] = true
        diff = 1
    }
    for k := range s {
        bl = bl && k > 0 && k < 4
    }
    if !bl {
        bl = true
        for k := range s {
            bl = bl && k < 0 && k > -4
        }
    }
    return bl
}

func main() {
    f, _ := os.Open("in.txt")
    defer f.Close()
    s, r, p1, p2 := bufio.NewScanner(f), regexp.MustCompile(`\d+`), 0, 0
    for s.Scan() {
        match := Map(r.FindAllStringSubmatch(s.Text(), -1), func (item []string) int { a,_ := strconv.Atoi(item[0]); return a })
        for bad := 0; bad < len(match); bad++ {
            if validate(match, bad) {
                p2 += 1
                break
            }
        }
        if validate(match, -1) {
            p1 += 1
        }
    }
    fmt.Println(p1)
    fmt.Println(p2)
}