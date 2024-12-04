open Base
open Stdio

type 'a grid = 'a array array

let make_grid lines ~dimx ~dimy =
  let grid = Array.make_matrix ~dimx ~dimy '0' in
  lines
  |> List.iteri ~f:(fun row_idx line ->
    List.iteri
      ~f:(fun col_idx elem -> grid.(row_idx).(col_idx) <- elem)
      (String.to_list line));
  grid
;;

let is_valid_idx i j grid =
  let len = Array.length grid in
  i >= 0 && i < len && j >= 0 && j < len
;;

let get_elem grid i j = if is_valid_idx i j grid then Some grid.(i).(j) else None

let part_1_new grid =
  let len = Array.length grid in
  let directions = [ 0, 1; 1, 0; 1, 1; 1, -1 ] in
  let extract_pattern ~i ~j ~steps:(di, dj) =
    let get_seq () =
      let a = get_elem grid (i + (0 * di)) (j + (0 * dj)) in
      let b = get_elem grid (i + (1 * di)) (j + (1 * dj)) in
      let c = get_elem grid (i + (2 * di)) (j + (2 * dj)) in
      let d = get_elem grid (i + (3 * di)) (j + (3 * dj)) in
      [ a; b; c; d ]
    in
    match List.filter_opt (get_seq ()) with
    | [ 'X'; 'M'; 'A'; 'S' ] | [ 'S'; 'A'; 'M'; 'X' ] -> true
    | _ -> false
  in
  let count = ref 0 in
  for i = 0 to len - 1 do
    for j = 0 to len - 1 do
      List.iter
        ~f:(fun (di, dj) ->
          if extract_pattern ~i ~j ~steps:(di, dj) then count := !count + 1)
        directions
    done
  done;
  !count
;;

let part_2 grid =
  let is_mas = function
    | [ 'M'; 'S' ] | [ 'S'; 'M' ] -> true
    | _ -> false
  in
  let len = Array.length grid in
  let count = ref 0 in
  for i = 0 to len - 1 do
    for j = 0 to len - 1 do
      match get_elem grid i j with
      | Some 'A' ->
        let diag1 = [ get_elem grid (i - 1) (j - 1); get_elem grid (i + 1) (j + 1) ] in
        let diag2 = [ get_elem grid (i - 1) (j + 1); get_elem grid (i + 1) (j - 1) ] in
        if (is_mas @@ List.filter_opt diag1) && (is_mas @@ List.filter_opt diag2)
        then count := !count + 1
      | _ -> ()
    done
  done;
  !count
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let rows = List.length lines in
  let cols = String.length @@ List.nth_exn lines 0 in
  let grid1 = make_grid lines ~dimx:rows ~dimy:cols in
  printf "\nPart 1: %d\n" @@ part_1_new grid1;
  printf "Part 2: %d\n" @@ part_2 grid1
;;

let () = solve "input.txt"
