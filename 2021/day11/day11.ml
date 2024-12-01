open Base
open Stdio

type 'a grid = 'a array array

let total_flashes = ref 0

let string_to_int_list str =
  str |> String.to_list |> List.map ~f:(fun ch -> Char.to_int ch - Char.to_int '0')
;;

let make_grid lines ~dimx ~dimy : int grid =
  let populate_row row_idx values grid =
    List.iteri ~f:(fun col_idx elem -> grid.(row_idx).(col_idx) <- elem) values
  in
  let rec aux idx grid lines =
    match lines with
    | [] -> grid
    | line :: rest ->
      let values = string_to_int_list line in
      populate_row idx values grid;
      aux (idx + 1) grid rest
  in
  let grid = Array.make_matrix ~dimx ~dimy 0 in
  aux 0 grid lines
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

let is_cave_open grid = Array.for_all ~f:(fun row -> Array.for_all ~f:(( = ) 0) row) grid

let run_step grid =
  let rows = Array.length grid in
  let cols = Array.length grid.(0) in
  let has_flashed = Array.make_matrix ~dimx:rows ~dimy:cols false in
  let is_valid i j = i >= 0 && i < rows && j >= 0 && j < cols in
  let rec update_adjs i j =
    if (not has_flashed.(i).(j)) && grid.(i).(j) > 9
    then (
      has_flashed.(i).(j) <- true;
      total_flashes := !total_flashes + 1;
      for di = -1 to 1 do
        for dj = -1 to 1 do
          if not (di = 0 && dj = 0)
          then (
            let ni = i + di in
            let nj = j + dj in
            if is_valid ni nj && not has_flashed.(ni).(nj)
            then (
              grid.(ni).(nj) <- grid.(ni).(nj) + 1;
              update_adjs ni nj))
        done
      done)
  in
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      grid.(i).(j) <- grid.(i).(j) + 1;
      if grid.(i).(j) > 9 then update_adjs i j
    done
  done;
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      if has_flashed.(i).(j)
      then (
        grid.(i).(j) <- 0;
        has_flashed.(i).(j) <- false)
    done
  done;
  is_cave_open grid
;;

let part_1 grid =
  for i = 1 to 100 do
    ignore (run_step grid)
  done
;;

let part_2 grid =
  let rec loop step =
    if run_step grid
    then (
      print_grid grid;
      step)
    else loop (step + 1)
  in
  loop 1
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let grid1 = make_grid lines ~dimx:10 ~dimy:10 in
  print_grid grid1;
  part_1 grid1;
  print_grid grid1;
  printf "\nTotal flashes: %d\n" !total_flashes;
  let grid2 = make_grid lines ~dimx:10 ~dimy:10 in
  printf "\nCavern is open after: %d steps\n" @@ part_2 grid2
;;

let () = solve "input.txt"

(*
   11111
   19991
   19191
   19991
   11111

   34543
   2iii2
   19103
   19991
   11111

   > Update each value by +1 starting by the top-left
   > If a value > 9 then update each adjacent element of it
   > Then0 for each one add 1
   > If by adding one to the adjacent element causes value > 9
   > Then find the adjacent elements of that element
   > and keep going recursively ...
   > After the whole process is finished, convert each value > 9 to 0

   di, dj -> delta changes
   ni, nj -> neighbors of i,j
*)
