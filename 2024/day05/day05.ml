open Base
open Stdio

let split_on_empty lines =
  let rec aux acc = function
    | [] -> List.rev acc, []
    | "" :: tl -> List.rev acc, tl
    | line :: tl -> aux (line :: acc) tl
  in
  aux [] lines
;;

let get_rules_table rules =
  let table = Hashtbl.create (module Int) in
  List.iter rules ~f:(fun rule ->
    match String.split_on_chars rule ~on:[ '|' ] with
    | [ num1; num2 ] ->
      let key = Int.of_string num1 in
      let value = Int.of_string num2 in
      Hashtbl.update table key ~f:(function
        | None -> [ value ]
        | Some values -> value :: values)
    | _ -> failwith "unreachable code");
  table
;;

let get_all_prints_values prints =
  List.map prints ~f:(fun line ->
    String.split_on_chars line ~on:[ ',' ] |> List.map ~f:Int.of_string)
;;

let is_print_in_order values table =
  let is_in_order key rest =
    let order_values =
      match Hashtbl.find table key with
      | Some rule_values -> rule_values
      | None -> []
    in
    List.for_all rest ~f:(fun rest_value ->
      List.mem order_values rest_value ~equal:Int.equal)
  in
  let rec loop = function
    | [] -> true
    | value :: rest -> if not (is_in_order value rest) then false else loop rest
  in
  loop values
;;

(*
   worth reading:
   https://www.reddit.com/r/adventofcode/comments/1h7mm3w/2024_day_05_part_2_how_nice_is_the_input_a_binary/
*)
let sort_with_rules rules values =
  let precedes x y rules =
    match Hashtbl.find rules x with
    | Some values -> List.mem values y ~equal:Int.equal
    | None -> false
  in
  List.sort values ~compare:(fun a b ->
    match a, b with
    | a, b when a = b -> 0
    | a, b when precedes a b rules -> -1
    | _ -> 1)
;;

let get_middle_value lst = List.nth_exn lst (List.length lst / 2)

let part_2 lines =
  let rules, prints = split_on_empty lines in
  let rules_table = get_rules_table rules in
  let all_print_values = get_all_prints_values prints in
  List.fold_left
    ~init:0
    ~f:(fun acc print_values ->
      if not (is_print_in_order print_values rules_table)
      then (
        let sorted = sort_with_rules rules_table print_values in
        let middle = get_middle_value sorted in
        acc + middle)
      else acc)
    all_print_values
;;

let part_1 lines =
  let rules, prints = split_on_empty lines in
  let rules_table = get_rules_table rules in
  let all_print_values = get_all_prints_values prints in
  List.fold_left
    ~init:0
    ~f:(fun acc print_values ->
      if is_print_in_order print_values rules_table
      then (
        let middle_idx = List.length print_values / 2 in
        acc + List.nth_exn print_values middle_idx)
      else acc)
    all_print_values
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  printf "\nPart 1: %d\n" @@ part_1 lines;
  printf "\nPart 2: %d\n" @@ part_2 lines
;;

let () = solve "input.txt"
