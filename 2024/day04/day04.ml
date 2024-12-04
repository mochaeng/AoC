open Base
open Stdio
open Angstrom

type 'a grid = 'a array array

let print_grid grid =
  printf "\n";
  let rows = Array.length grid in
  for i = 0 to rows - 1 do
    let cols = Array.length grid.(i) in
    for j = 0 to cols - 1 do
      printf "%c " grid.(i).(j)
    done;
    printf "\n"
  done
;;

let xmas_parser = string "XMAS" *> return 1
let skip_unrelated = advance 1 *> return None

let count_line_occurrences line =
  line
  |> parse_string
       ~consume:All
       (choice [ xmas_parser >>| Option.some; skip_unrelated ] |> many >>| List.filter_opt)
  |> function
  | Ok values -> List.fold ~init:0 ~f:( + ) values
  | Error _ -> 0
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

let get_row_string row = String.init (Array.length row) ~f:(Array.get row)

let get_column_string grid col_idx =
  String.init (Array.length grid) ~f:(fun row_idx -> grid.(row_idx).(col_idx))
;;

let is_valid i j grid =
  let len = Array.length grid in
  i >= 0 && i < len && j >= 0 && j < len
;;

let get_bottom_diagonal_above_main ~i ~j grid =
  let rec loop acc i' j' =
    if is_valid i' j' grid then loop (grid.(i').(j') :: acc) (i' + 1) (j' + 1) else acc
  in
  List.rev (loop [] i j)
;;

let get_bottom_diagonal_down_main ~i ~j grid =
  let rec loop acc i' j' =
    if is_valid i' j' grid then loop (grid.(i').(j') :: acc) (i' + 1) (j' - 1) else acc
  in
  List.rev (loop [] i j)
;;

let get_upper_diagonal_above_main ~i ~j grid =
  let rec loop acc i' j' =
    if is_valid i' j' grid then loop (grid.(i').(j') :: acc) (i' - 1) (j' + 1) else acc
  in
  List.rev (loop [] i j)
;;

let get_upper_diagonal_above_main ~i ~j grid =
  let rec loop acc i' j' =
    if is_valid i' j' grid then loop (grid.(i').(j') :: acc) (i' - 1) (j' + 1) else acc
  in
  List.rev (loop [] i j)
;;

let get_all_diagonals_from_grid (grid : char array array) =
  let len = Array.length grid in
  let elements = ref [] in
  for i = 0 to len - 1 do
    let bottom_diag =
      get_bottom_diagonal_above_main ~i ~j:0 grid |> String.of_char_list
    in
    let upper_diag = get_upper_diagonal_above_main ~i ~j:0 grid |> String.of_char_list in
    elements := bottom_diag :: upper_diag :: !elements
  done;
  for i = 1 to len - 2 do
    let bottom_diag =
      get_bottom_diagonal_above_main ~i ~j:(len - 1) grid |> String.of_char_list
    in
    let upper_diag =
      get_upper_diagonal_above_main ~i ~j:(len - 1) grid |> String.of_char_list
    in
    elements := bottom_diag :: upper_diag :: !elements
  done;
  printf "\nThe size is: %d\n" @@ List.length !elements;
  !elements
;;

let part_1 (grid : char array array) =
  let rows_sum =
    Array.fold
      ~init:0
      ~f:(fun acc row ->
        let row_string = get_row_string row in
        let forward_count = count_line_occurrences row_string in
        let reversed_count = count_line_occurrences (String.rev row_string) in
        acc + forward_count + reversed_count)
      grid
  in
  let cols_sum =
    Array.foldi
      ~init:0
      ~f:(fun idx acc row ->
        let col_string = get_column_string grid idx in
        let forward_count = count_line_occurrences col_string in
        let reversed_count = count_line_occurrences (String.rev col_string) in
        acc + forward_count + reversed_count)
      grid
  in
  let diags_sum =
    get_all_diagonals_from_grid grid
    |> List.filter ~f:(fun diag -> String.length diag >= 0)
    |> List.fold_left ~init:0 ~f:(fun acc diag ->
      let forward_count = count_line_occurrences diag in
      let reversed_count = count_line_occurrences (String.rev diag) in
      printf "\n%s -> %d %d" diag forward_count reversed_count;
      acc + forward_count + reversed_count)
  in
  rows_sum + cols_sum + diags_sum
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let rows = List.length lines in
  let cols = String.length @@ List.nth_exn lines 0 in
  let grid1 = make_grid lines ~dimx:rows ~dimy:cols in
  print_grid grid1;
  printf "\n\n%d\n" @@ part_1 grid1
;;

(* printf "\n\n%d\n" @@ count_line_occurrences (String.rev "MXMXAXMASX");
  printf "\n\n%s\n" @@ String.rev "MXMXAXMASX" *)

let () = solve "test.txt"

(* o o o o X X M A S o
o S A M X M S o o o
o o o S o o A o o o
o o A o A o M S o X
X M A S A M X o M M
X o o o o o X A o A
S o S o S o S o S S
o A o A o A o A o A
o o M o M o M o M M
o X o X o X M A S X  *)
