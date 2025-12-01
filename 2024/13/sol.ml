let input = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let machines = 
   let rec get_list_of_machines current_list all_lists reading_list =
      match reading_list with
      | "" :: tail -> get_list_of_machines [] (current_list :: all_lists) tail
      | line :: tail -> get_list_of_machines (line :: current_list) all_lists tail
      | _ -> current_list :: all_lists
   in

   let parse_numbers_part c part = 
      let numbers_list = part
         |> String.split_on_char ','
         |> List.map (fun el -> 
            el
            |> String.trim
            |> String.split_on_char c
            |> List.tl |> List.hd
            |> float_of_string
         )
      in
      match numbers_list with
      | x :: y :: [] -> (x, y)
      | _ -> failwith "Failed to parse numbers part"
   in

   let parse_machine machine =
      match machine with
      | result_line :: button_b_line :: button_a_line :: [] ->
         let buttons_a = button_a_line
            |> String.split_on_char ':'
            |> List.tl |> List.hd
            |> parse_numbers_part '+'
         in

         let buttons_b = button_b_line
            |> String.split_on_char ':'
            |> List.tl |> List.hd
            |> parse_numbers_part '+'
         in

         let result = result_line
            |> String.split_on_char ':'
            |> List.tl |> List.hd
            |> parse_numbers_part '='
         in
         (*
         let (bax, bay) = buttons_a in
         let (bbx, bby) = buttons_b in
         let (rx, ry) = result in
         let () = Printf.printf "Parsed: %f %f - %f %f - %f %f\n" bax bay bbx bby rx ry in
         *)
         (buttons_a, buttons_b, result)
      | _ -> failwith "Invalid machine"
   in
   input
   |> get_list_of_machines [] []
   |> List.map parse_machine ;;


let are_buttons_colinear (b1x, b1y) (b2x, b2y) =
   b1x *. b2y = b1y *. b2x ;;

let is_int v =
   abs_float (v -. Float.round v) < 0.001 ;;

let get_tokens_if_winnable result_offset ((bax, bay), (bbx, bby), (_rx, _ry)) =
   if are_buttons_colinear (bax, bay) (bbx, bby) then
      let () = Printf.printf "Unhandled: %f %f - %f %f\n" bax bay bbx bby in
      0
   else
      let rx = _rx +. result_offset in
      let ry = _ry +. result_offset in
      let a_denom = bax -. (bay *. bbx)/.bby in
      let a_count = (rx -. (bbx *. ry)/.bby) /. a_denom in
      let b_count = (ry -. bay *. a_count) /. bby in
      let cond1 = is_int a_count in
      let cond2 = is_int b_count in
      (* let () = Printf.printf "(%b, %b): %f %f - %f %f: %f %f\n" cond1 cond2 bax bay bbx bby a_count b_count in *)
      (if cond1 && cond2 then (int_of_float (Float.round a_count)) * 3 + (int_of_float (Float.round b_count)) else 0)


let result1 =
   machines
   |> List.map (fun machine -> get_tokens_if_winnable 0.0 machine)
   |> List.fold_left (+) 0 ;;

let result2 =
   machines
   |> List.map (fun machine -> get_tokens_if_winnable 10000000000000.0 machine)
   |> List.fold_left (+) 0 ;;


let () = Printf.printf "Silver: %d\n" result1 ;;
let () = Printf.printf "Gold: %d\n" result2 ;;
