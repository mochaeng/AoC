open Stdio
open Base

module RecordedDirection = struct
  module T = struct
    type t = int * int * char [@@deriving sexp_of, compare, show, hash]
  end

  include T
  include Comparable.Make (T)
end

let make_grid_from grid ~default =
  Array.make_matrix ~dimx:(Array.length grid) ~dimy:(Array.length grid.(0)) default
;;

let make_grid lines ~dimx ~dimy =
  let grid = Array.make_matrix ~dimx ~dimy '0' in
  lines
  |> List.iteri ~f:(fun row_idx line ->
    List.iteri
      ~f:(fun col_idx elem -> grid.(row_idx).(col_idx) <- elem)
      (String.to_list line));
  grid
;;

let is_idx_out_of_bounds i j grid =
  let len = Array.length grid in
  i >= 0 && i < len && j >= 0 && j < len
;;

let get_elem grid ~idxs:(i, j) =
  if is_idx_out_of_bounds i j grid then Some grid.(i).(j) else None
;;

let find_guard_idx grid =
  let arrows = [ '^'; 'v'; '>'; '<' ] in
  Array.find_mapi grid ~f:(fun i row ->
    Array.find_mapi row ~f:(fun j ch ->
      if List.mem arrows ch ~equal:Char.equal then Some (i, j, ch) else None))
;;

let find_guard_next_move ~idxs:(i, j) = function
  | '^' -> i - 1, j
  | '>' -> i, j + 1
  | 'v' -> i + 1, j
  | '<' -> i, j - 1
  | _ -> failwith "unreachable"
;;

let turn_position_90_deg_right = function
  | '^' -> '>'
  | '>' -> 'v'
  | 'v' -> '<'
  | '<' -> '^'
  | _ -> failwith "unreachable"
;;

let has_cycle grid =
  let recorded_directions =
    Hash_set.create (module RecordedDirection) ~growth_allowed:true ~size:22500
  in
  let rec loop ~idxs:(cur_i, cur_j) ~arrow:cur_arrow =
    let new_direction = cur_i, cur_j, cur_arrow in
    if Hash_set.mem recorded_directions new_direction
    then true
    else (
      Hash_set.add recorded_directions new_direction;
      let next_i, next_j = find_guard_next_move ~idxs:(cur_i, cur_j) cur_arrow in
      let next_element = get_elem grid ~idxs:(next_i, next_j) in
      match next_element with
      | Some '.' ->
        grid.(cur_i).(cur_j) <- '.';
        grid.(next_i).(next_j) <- cur_arrow;
        loop ~idxs:(next_i, next_j) ~arrow:cur_arrow
      | Some '#' ->
        let turn_arrow = turn_position_90_deg_right cur_arrow in
        grid.(cur_i).(cur_j) <- turn_arrow;
        loop ~idxs:(cur_i, cur_j) ~arrow:turn_arrow
      | _ -> false)
  in
  let first_i, first_j, arrow = Option.value_exn @@ find_guard_idx grid in
  loop ~idxs:(first_i, first_j) ~arrow
;;

let part_2 original_grid =
  let count = ref 0 in
  let len = Array.length original_grid in
  for i = 0 to len - 1 do
    for j = 0 to len - 1 do
      if Char.equal original_grid.(i).(j) '.'
      then (
        let alter_grid = Array.map ~f:Array.copy original_grid in
        alter_grid.(i).(j) <- '#';
        if has_cycle alter_grid then count := !count + 1;
        alter_grid.(i).(j) <- '.')
    done
  done;
  !count
;;

let part_1 grid =
  let rec loop ~idxs:(cur_i, cur_j) ~arrow ~guard_paths =
    guard_paths.(cur_i).(cur_j) <- 'X';
    let next_i, next_j = find_guard_next_move ~idxs:(cur_i, cur_j) arrow in
    let next_element = get_elem grid ~idxs:(next_i, next_j) in
    match next_element with
    | Some '.' ->
      grid.(cur_i).(cur_j) <- '.';
      grid.(next_i).(next_j) <- arrow;
      loop ~idxs:(next_i, next_j) ~arrow ~guard_paths
    | Some '#' ->
      let turn_arrow = turn_position_90_deg_right arrow in
      grid.(cur_i).(cur_j) <- turn_arrow;
      loop ~idxs:(cur_i, cur_j) ~arrow:turn_arrow ~guard_paths
    | _ -> guard_paths
  in
  let guard_paths = make_grid_from grid ~default:'o' in
  let first_i, first_j, arrow = Option.value_exn @@ find_guard_idx grid in
  guard_paths.(first_i).(first_j) <- 'X';
  let filled_positions = loop ~idxs:(first_i, first_j) ~arrow ~guard_paths in
  Array.fold
    ~init:0
    ~f:(fun acc row -> acc + Array.count row ~f:(Char.equal 'X'))
    filled_positions
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let rows = List.length lines in
  let cols = String.length @@ List.nth_exn lines 0 in
  let grid1 = make_grid lines ~dimx:rows ~dimy:cols in
  let grid2 = make_grid lines ~dimx:rows ~dimy:cols in
  printf "\nPart 1: %d\n" @@ part_1 grid1;
  printf "\nPart 2: %d\n" @@ part_2 grid2
;;

let () = solve "input.txt"
