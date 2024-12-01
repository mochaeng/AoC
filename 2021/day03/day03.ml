open Base
open Stdio

type 'a grid = 'a array array

let string_to_int_list str =
  str |> String.to_list |> List.map ~f:(fun ch -> Char.to_int ch - Char.to_int '0')
;;

let print_grid grid =
  printf "\n";
  let rows = Array.length grid in
  for i = 0 to rows - 1 do
    let cols = Array.length grid.(i) in
    for j = 0 to cols - 1 do
      printf "%d " grid.(i).(j)
    done;
    printf "\n"
  done
;;

let make_grid lines ~dimx ~dimy =
  let populate_row row_idx values grid =
    List.iteri values ~f:(fun col_idx elem -> grid.(row_idx).(col_idx) <- elem)
  in
  let rec aux idx grid = function
    | [] -> grid
    | line :: rest ->
      let values = string_to_int_list line in
      populate_row idx values grid;
      aux (idx + 1) grid rest
  in
  let grid = Array.make_matrix ~dimx ~dimy 0 in
  aux 0 grid lines
;;

let count_column_bits_of grid ~j ~bit =
  Array.foldi grid ~init:0 ~f:(fun i acc _ -> acc + (grid.(i).(j) land bit))
;;

let part_1 grid ~dimx ~dimy =
  let most_common_bit ~j =
    let one_count = count_column_bits_of grid ~j ~bit:1 in
    if one_count >= dimx / 2 then 1 else 0
  in
  let gamma_rate = ref 0 in
  let epsilon_rate = ref 0 in
  for j = 0 to dimy - 1 do
    let common = most_common_bit ~j in
    let least = if common = 0 then 1 else 0 in
    gamma_rate := (!gamma_rate lsl 1) lor common;
    epsilon_rate := (!epsilon_rate lsl 1) lor least
  done;
  !gamma_rate * !epsilon_rate
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let rows = List.length lines in
  let cols = String.length @@ List.nth_exn lines 0 in
  let grid = make_grid lines ~dimx:rows ~dimy:cols in
  printf "\n%d\n" @@ part_1 grid ~dimx:rows ~dimy:cols
;;

let () = solve "input.txt"
