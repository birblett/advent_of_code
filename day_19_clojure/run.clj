(defn parse_in [] (to-array (clojure.string/split (slurp "in.txt") #"\n\n" )))
(def patterns (clojure.string/split (aget (parse_in) 0) #", "))
(def towels (clojure.string/split (aget (parse_in) 1) #"\n"))

(def memct (memoize (fn [str]
  (cond
    (= (count str) 0) 1
    :else (reduce + (map (fn [s] (cond (clojure.string/starts-with? str s) (memct (subs str (count s))) :else 0)) patterns))))))

(println (reduce (fn [i, j] (cond (> j 0) (+ i 1) :else i)) (map memct towels)) (reduce + (map memct towels)))