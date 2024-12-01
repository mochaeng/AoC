open Base
open Stdio

let create_sorted_columns lines =
  let parse_line line =
    let parsed =
      line
      |> String.split_on_chars ~on:[ ' ' ]
      |> List.filter ~f:(fun s -> not (String.is_empty s))
    in
    match parsed with
    | [ num1; num2 ] -> Some (Int.of_string num1, Int.of_string num2)
    | _ -> None
  in
  lines
  |> List.filter_map ~f:parse_line
  |> List.unzip
  |> fun (col1, col2) ->
  List.sort ~compare:Int.compare col1, List.sort ~compare:Int.compare col2
;;

let count_occurrences table key =
  match Hashtbl.find table key with
  | None -> 0
  | Some v -> v
;;

let occurrences_table numbers =
  let table = Hashtbl.create ~size:(List.length numbers) (module Int) in
  List.iter numbers ~f:(fun num ->
    Hashtbl.update table num ~f:(function
      | None -> 1
      | Some count -> count + 1));
  table
;;

let part_1 col1 col2 =
  let distance num1 num2 = abs (num1 - num2) in
  List.fold2_exn col1 col2 ~init:0 ~f:(fun acc num1 num2 -> acc + distance num1 num2)
;;

let part_2 col1 col2 =
  let occurrences = occurrences_table col2 in
  List.fold
    ~init:0
    ~f:(fun acc value -> acc + (value * count_occurrences occurrences value))
    col1
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let col1, col2 = create_sorted_columns lines in
  printf "\npart 1: %d\n" @@ part_1 col1 col2;
  printf "part 2: %d\n" @@ part_2 col1 col2
;;

let () = solve "input.txt"
