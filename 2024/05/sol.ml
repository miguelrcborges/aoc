let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let (conditions_strs, updates_strs) =
   let rec parse_conditions ol lines =
      match lines with
      | "" :: ls -> (ol, ls)
      | s :: ls -> parse_conditions (s :: ol) ls
      | _ -> failwith "Failed to parse lines"
   in
   parse_conditions [] lines ;;


module IntMap = Map.Make(Int)
module IntSet = Set.Make(Int)

let conditions = 
   List.fold_left (fun acc condition_str -> 
      let (previous_n_str, next_n_str) = 
         match String.split_on_char '|' condition_str with
         | first :: second :: [] -> (first, second)
         | _ -> failwith "Invalid condition"
      in
      let previous_n = int_of_string previous_n_str in
      let next_n = int_of_string next_n_str in
      let current_list = match IntMap.find_opt previous_n acc with
      | Some l -> l
      | None -> []
      in
      IntMap.add previous_n (next_n :: current_list) acc
   ) IntMap.empty conditions_strs ;;

let updates = 
   List.map (fun str ->
      let numbers_str = String.split_on_char ',' str in
      List.map int_of_string numbers_str
   ) updates_strs

let is_update_valid update = 
   let rec check remaining passed = 
      match remaining with
      | current :: to_check ->
            let dependencies = (match IntMap.find_opt current conditions with
            | Some d -> d
            | None -> [])
            in
            let is_element_valid = List.for_all (fun dependency -> 
               not (IntSet.mem dependency passed)
            ) dependencies
            in
            if is_element_valid then check to_check (IntSet.add current passed)
            else false
      | _ -> true in
   check update IntSet.empty ;;


let result1 = 
   let valid_updates = List.filter is_update_valid updates in
   let middle_values = List.map (fun l ->
      let length = List.length l in
      let middle = (length / 2) in
      List.nth l middle 
   ) valid_updates in
   List.fold_left (+) 0 middle_values ;;

Printf.printf "Silver: %d\n" result1 ;;

let make_update_valid update = 
   let rec fix remaining update_output passed = 
      match remaining with
      | current :: to_check ->
            let dependencies = (match IntMap.find_opt current conditions with
            | Some d -> d
            | None -> [])
            in
            let is_element_valid = List.for_all (fun dependency -> 
               not (IntSet.mem dependency passed)
            ) dependencies
            in
            if is_element_valid then fix to_check (current :: update_output) (IntSet.add current passed)
            else fix (current :: ((List.rev update_output) @ to_check)) [] IntSet.empty
      | _ -> update_output in
   fix update [] IntSet.empty ;;


let result2 = 
   let invalid_updates = List.filter (fun l -> not (is_update_valid l)) updates in
   let fixed_lists = List.map make_update_valid invalid_updates in
   let middle_values = List.map (fun l ->
      let length = List.length l in
      let middle = (length / 2) in
      List.nth l middle 
   ) fixed_lists in
   List.fold_left (+) 0 middle_values ;;

Printf.printf "Gold: %d\n" result2 ;;
