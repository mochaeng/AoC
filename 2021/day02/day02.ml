open Base
open Stdio

type coordinate =
  { horizontal : int
  ; depth : int
  }

type aimed_coordinate =
  { aim : int
  ; horizontal : int
  ; depth : int
  }

let next_coordinate (prev : coordinate) = function
  | "forward", amount -> { prev with horizontal = prev.horizontal + amount }
  | "down", amount -> { prev with depth = prev.depth + amount }
  | "up", amount -> { prev with depth = prev.depth - amount }
  | _ -> prev
;;

let next_aimed_coordinate prev = function
  | "forward", amount ->
    { prev with
      horizontal = prev.horizontal + amount
    ; depth = prev.depth + (prev.aim * amount)
    }
  | "down", amount -> { prev with aim = prev.aim + amount }
  | "up", amount -> { prev with aim = prev.aim - amount }
  | _ -> prev
;;

let get_command line =
  let parts = String.split_on_chars ~on:[ ' ' ] line in
  let order = Option.value ~default:"" @@ List.nth parts 0 in
  let amount = Int.of_string @@ Option.value ~default:"0" @@ List.nth parts 1 in
  order, amount
;;

let part1 lines =
  let rec aux acc = function
    | [] -> acc
    | hd :: tl ->
      let command = get_command hd in
      let new_coord = next_coordinate acc command in
      aux new_coord tl
  in
  let final_coord = aux { horizontal = 0; depth = 0 } lines in
  final_coord.horizontal * final_coord.depth
;;

let part2 lines =
  let rec aux acc = function
    | [] -> acc
    | hd :: tl ->
      let command = get_command hd in
      let new_coord = next_aimed_coordinate acc command in
      aux new_coord tl
  in
  let final_coord = aux { horizontal = 0; depth = 0; aim = 0 } lines in
  final_coord.horizontal * final_coord.depth
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  printf "\npart1: %d\n" @@ part1 lines;
  printf "part2: %d\n" @@ part2 lines
;;

let () = solve "input.txt"
