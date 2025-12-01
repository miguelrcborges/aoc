let lines = In_channel.input_lines (In_channel.open_text "input.txt") ;;

let reports =
   List.map (fun line ->
      let line_reports = String.split_on_char ' ' line in
      List.map int_of_string line_reports
   ) lines ;;

let rec is_increasing num_list =
   match num_list with
   | x :: y :: tail -> (y > x && x + 4 > y) && is_increasing (y :: tail)
   | [] | [_] -> true ;;

let rec is_decreasing num_list =
   match num_list with
   | x :: y :: tail -> (y < x && y + 4 > x) && is_decreasing (y :: tail)
   | [] | [_] -> true ;;


let result_part1 =
   let safe_reports =
      List.filter (fun report -> is_increasing report || is_decreasing report) reports in
   List.length safe_reports ;;

Printf.printf "%d\n" result_part1 ;;

let rec torable_is_increasing previous_value num_list has_skipped =
   match num_list with
   | [] -> true
   | x :: tail -> 
      if x > previous_value && previous_value + 4 > x then 
         torable_is_increasing x tail has_skipped
      else if has_skipped then
         false
      else
         torable_is_increasing previous_value tail true ;;


let rec torable_is_decreasing previous_value num_list has_skipped =
   match num_list with
   | [] -> true
   | x :: tail -> 
      if x < previous_value && x + 4 > previous_value then 
         torable_is_decreasing x tail has_skipped
      else if has_skipped then
         false
      else
         torable_is_decreasing previous_value tail true ;;


let result_part2 =
   let safe_reports =
      List.filter (fun levels_list ->
         match levels_list with
         | first :: tail ->
            let cond1 = torable_is_increasing first tail false in
            let cond2 = torable_is_decreasing first tail false in
            let cond3 = is_increasing tail in
            let cond4 = is_decreasing tail in
            cond1 || cond2 || cond3 || cond4
         | _ -> failwith "Invalid levels list"
      ) reports in
   List.length safe_reports ;;

Printf.printf "%d\n" result_part2 ;;
