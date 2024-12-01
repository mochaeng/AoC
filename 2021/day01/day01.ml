open Base
open Stdio

let part1 lines =
  let rec aux acc prev = function
    | [] -> acc
    | hd :: tl -> if hd > prev then aux (acc + 1) hd tl else aux acc hd tl
  in
  let first_element =
    match lines with
    | [] -> 0
    | hd :: _ -> hd
  in
  aux 0 first_element lines
;;

let part2 lines =
  let rec aux acc prev = function
    | [] -> acc
    | hd :: tl ->
      let sum_window =
        match tl with
        | el1 :: el2 :: _ -> hd + el1 + el2
        | _ -> 0
      in
      if sum_window > prev then aux (acc + 1) sum_window tl else aux acc sum_window tl
  in
  let first_element =
    match lines with
    | el1 :: el2 :: el3 :: _ -> el1 + el2 + el3
    | _ -> 0
  in
  aux 0 first_element lines
;;

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  let numbers = List.map lines ~f:(fun elem -> Int.of_string elem) in
  printf "\n%d\n" @@ part1 numbers;
  printf "%d\n" @@ part2 numbers
;;

let () = solve "input.txt"
