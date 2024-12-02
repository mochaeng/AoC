open Base
open Stdio

let check arr ~f =
  Array.for_alli
    ~f:(fun idx current -> if idx = 0 then true else f current arr.(idx - 1))
    arr
;;

let get_arr_from_line line =
  line
  |> String.split ~on:' '
  |> List.filter ~f:(fun s -> not (String.is_empty s))
  |> List.map ~f:Int.of_string
  |> Array.of_list
;;

let is_report_safe arr =
  let is_increasing =
    check
      ~f:(fun current prev ->
        let value = current - prev in
        value >= 1 && value <= 3)
      arr
  in
  let is_decreasing =
    check
      ~f:(fun current prev ->
        let value = current - prev in
        value >= -3 && value <= -1)
      arr
  in
  (is_increasing && not is_decreasing) || (is_decreasing && not is_increasing)
;;

let is_report_safe_with_dampener arr =
  let can_ben_safe arr =
    Array.existsi arr ~f:(fun pos _ ->
      let subarr = Array.filteri arr ~f:(fun idx _ -> idx <> pos) in
      is_report_safe subarr)
  in
  is_report_safe arr || can_ben_safe arr
;;

let count_safe_reports lines ~f =
  let rec aux acc = function
    | [] -> acc
    | hd :: tl -> if f (get_arr_from_line hd) then aux (acc + 1) tl else aux acc tl
  in
  aux 0 lines
;;

let part_1 lines = count_safe_reports ~f:is_report_safe lines
let part_2 lines = count_safe_reports ~f:is_report_safe_with_dampener lines

let solve filename =
  let content = In_channel.read_all filename in
  let lines = String.split_lines content in
  printf "\nPart 1: %d\n" @@ part_1 lines;
  printf "\nPart 2: %d\n" @@ part_2 lines
;;

let () = solve "input.txt"
