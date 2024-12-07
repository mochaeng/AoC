open Stdio
open Base

let parse_line line =
  line
  |> String.split_on_chars ~on:[ ':' ]
  |> function
  | [ target; numbers ] ->
    let target = Int.of_string target in
    let numbers =
      numbers
      |> String.split_on_chars ~on:[ ' ' ]
      |> List.filter ~f:(fun s -> String.is_empty s |> not)
      |> List.map ~f:Int.of_string
      |> Array.of_list
    in
    target, numbers
  | _ -> failwith "Invalid input format"
;;

let concate_two_integers x y =
  let digits = Int.of_float @@ (Float.log10 (Float.of_int y) +. 1.0) in
  let shifted = x * Int.pow 10 digits in
  shifted + y
;;

let with_two_operators num values ~target =
  List.fold values ~init:[] ~f:(fun acc v ->
    let add = v + num in
    let multiply = v * num in
    let acc = if add <= target then add :: acc else acc in
    if multiply <= target then multiply :: acc else acc)
;;

let with_three_operators num values ~target =
  List.fold values ~init:[] ~f:(fun acc v ->
    let add = v + num in
    let multiply = v * num in
    let concat = concate_two_integers v num in
    let acc = if add <= target then add :: acc else acc in
    let acc = if multiply <= target then multiply :: acc else acc in
    if concat <= target then concat :: acc else acc)
;;

let compute_possibilities values ~f:operators ~target =
  let len = Array.length values in
  let rec loop idx acc =
    if idx = len - 1
    then acc
    else (
      let next = values.(idx + 1) in
      loop (idx + 1) (operators next acc ~target))
  in
  loop 0 [ values.(0) ]
;;

let part_2 lines =
  lines
  |> List.map ~f:(fun line -> parse_line line)
  |> List.map ~f:(fun (target, values) ->
    let possibilities = compute_possibilities values ~f:with_three_operators ~target in
    if List.exists possibilities ~f:(fun v -> v = target) then target else 0)
  |> List.fold_left ~init:0 ~f:(fun acc v -> acc + v)
;;

let part_1 lines =
  lines
  |> List.map ~f:(fun line -> parse_line line)
  |> List.map ~f:(fun (target, values) ->
    let possibilities = compute_possibilities values ~f:with_two_operators ~target in
    if List.exists possibilities ~f:(fun v -> v = target) then target else 0)
  |> List.fold_left ~init:0 ~f:(fun acc v -> acc + v)
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  printf "\nPart 1: %d\n" @@ part_1 lines;
  printf "\nPart 2: %d\n" @@ part_2 lines
;;

let () = solve "input.txt"
