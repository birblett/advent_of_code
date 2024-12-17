import kotlin.math.pow

fun main() {
    var h = java.io.File("in.txt").readText().trim().split(' ').groupingBy { it.toLong() }.eachCount().mapValues { (_, i) -> i.toLong() }
    for (i in 1..75) {
        val j = hashMapOf<Long,Long>()
        h.forEach { (k, v) ->
            if (k == 0L) j[1] = j.getOrDefault(1, 0) + v
            else (kotlin.math.log10(k.toDouble()) + 1).toInt().also { t ->
                if (t.and(1) == 0) (10.0.pow(t / 2).toInt()).also {
                    j[k / it] = j.getOrDefault(k / it, 0) + v
                    j[k % it] = j.getOrDefault(k % it, 0) + v
                } else j[k * 2024] = j.getOrDefault(k * 2024, 0) + v
            }
        }
        h = j
        if (i == 25 || i == 75) println(h.values.sum())
    }
}