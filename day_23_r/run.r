#!/usr/bin/env Rscript
connections <- new.env()
con <- function(a, b) !is.null(connections[[a]][[b]])
n <- c()
for (i in readLines("in.txt")) {
    a <- strsplit(i, "-")[[1]]
    if (is.null(connections[[a[1]]])) connections[[a[1]]] = new.env()
    connections[[a[1]]][[a[2]]] = TRUE
    if (is.null(connections[[a[2]]])) connections[[a[2]]] = new.env()
    connections[[a[2]]][[a[1]]] = TRUE
    n <- c(n, a[1], a[2])
}
n <- unique(n)
len <- length(n)
result <- c()
final <- new.env()
for (a in n) for (b in ls(envir = connections[[a]])) for (c in ls(envir = connections[[b]])) if (con(a, c) && (startsWith(a, "t") || startsWith(b, "t") || startsWith(c, "t"))) {
    res <- c(a, b, c)
    res <- res[order(res)]
    final[[paste(res[1], res[2], res[3])]] = TRUE
}
for (i in 1:len) {
    res <- c(n[i])
    for (j in 1:len) if (j != i) {
        add <- TRUE
        for (r in res) if (!con(r, n[j])) {
            add <- FALSE
            break
        }
        if (add) res <- c(res, n[j])
    }
    if (length(res) > length(result)) result <- res
}
print(length(ls(envir=final)))
print(paste(result[order(result)],collapse=','))