module Keypad = Map.Make(Char);;

let lines file = In_channel.with_open_text file In_channel.input_all |> String.split_on_char '\n';;
let cache = Hashtbl.create 512;;

let expand lstr iters =
  let keys = Keypad.of_seq @@ List.to_seq [
    ('7', (0, 0)); ('8', (1, 0)); ('9', (2, 0)); ('4', (0, 1)); ('5', (1, 1)); ('6', (2, 1)); ('1', (0, 2)); ('2', (1, 2)); ('3', (2, 2)); ('0', (1, 3)); ('A', (2, 3));
    ('^', (1, 0)); ('a', (2, 0)); ('<', (0, 1)); ('v', (1, 1)); ('>', (2, 1));
  ] in
  let rec rep n s = if n = 0 then "" else s ^ rep (n - 1) s in
  let rec expand_path st depth start =
    try Hashtbl.find cache (st, depth)
    with Not_found ->
      match depth with
      | 0 -> String.length st
      | _ -> let st1 = (if depth == start then "A" else "a") ^ st in
             let offsets = List.init ((String.length st1) - 1) (fun idx ->
               let (x1, y1) = Keypad.find st1.[idx] keys in
               let (x2, y2) = Keypad.find st1.[idx + 1] keys in
               (st1.[idx], x1, y1, st1.[idx + 1], x2, y2)) in
             let cool = List.map (fun (c1, x1, y1, c2, x2, y2) ->
               let f = if depth == start then (0, 3) else (0, 0) in
               let h = rep (Int.abs (x1 - x2)) (if x1 > x2 then "<" else ">") in
               let v = rep (Int.abs (y1 - y2)) (if y1 > y2 then "^" else "v") in
               let hf = if (x2, y1) = f then 100000000000 else expand_path (h ^ v ^ "a") (depth - 1) start in
               let vf = if (x1, y2) = f then 100000000000 else expand_path (v ^ h ^ "a") (depth - 1) start in
               if hf > vf then vf else hf) offsets in
             let i = (List.fold_left (+) 0 cool) in
             Hashtbl.add cache (st, depth) i;
             i
  in List.map (fun s -> (int_of_string (String.sub s 0 3)) * (expand_path s (iters + 1) (iters + 1))) lstr;;

Printf.printf "p1: %d\np2: %d\n" (List.fold_left (+) 0 (expand (lines "in.txt") 2)) (List.fold_left (+) 0 (expand (lines "in.txt") 25));;