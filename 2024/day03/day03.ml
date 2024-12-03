open Base
open Stdio
open Angstrom

type action =
  | Mul of int
  | Do of bool

let parse_line line parser =
  match parse_string ~consume:All parser line with
  | Ok results -> results
  | Error err -> failwith ("Parsing error: " ^ err)
;;

let integer = take_while1 Char.is_digit >>| Int.of_string

let mul_parser =
  string "mul("
  *> lift2 (fun x y -> Mul (x * y)) (integer <* char ',') (integer <* char ')')
;;

let do_parser = string "do()" *> return (Do true)
let dont_parser = string "don't()" *> return (Do false)
let skip_unrelated = advance 1 *> return None

let part_1 lines =
  let result_parser = choice [ mul_parser >>| Option.some; skip_unrelated ] in
  let parser = many result_parser >>| List.filter_opt in
  lines
  |> List.concat_map ~f:(fun line -> parse_line line parser)
  |> List.fold ~init:0 ~f:(fun acc result ->
    match result with
    | Mul x -> acc + x
    | Do _ -> acc)
;;

let compute_allowed_sum results =
  let should_sum = ref true in
  let rec aux acc = function
    | [] -> acc
    | Mul x :: rest -> if !should_sum then aux (acc + x) rest else aux acc rest
    | Do is :: rest ->
      should_sum := is;
      aux acc rest
  in
  aux 0 results
;;

let part_2 lines =
  let result_parser =
    choice
      [ mul_parser >>| Option.some
      ; do_parser >>| Option.some
      ; dont_parser >>| Option.some
      ; skip_unrelated
      ]
  in
  let parser = many result_parser >>| List.filter_opt in
  lines |> List.concat_map ~f:(fun line -> parse_line line parser) |> compute_allowed_sum
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  printf "\nPart 1:%d\n" @@ part_1 lines;
  printf "\nPart 2:%d\n" @@ part_2 lines
;;

let () = solve "input.txt"
