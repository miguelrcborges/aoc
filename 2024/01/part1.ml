let lines = In_channel.input_lines (In_channel.open_text "input.txt") ;;

let columns =
   List.fold_left (fun (left_list, right_list) elem ->
      let numbers_str_list_with_empties = String.split_on_char ' ' elem in
      let numbers_str = List.filter (fun s -> s <> "") numbers_str_list_with_empties in
      let numbers = List.map int_of_string numbers_str in
      match numbers with
      | left :: right :: [] -> left :: left_list, right :: right_list
      | _ -> failwith "Failed to parse set."
   ) ([], []) lines ;;


let columns_sorted =
   let sort_columns = (fun (left, right) -> 
      let left_sorted = List.sort compare left in
      let right_sorted = List.sort compare right in
      (left_sorted, right_sorted)
   ) in 
   sort_columns columns ;;

let solution = 
   let (left_column, right_column) = columns_sorted in
   List.fold_left2 (fun acc left right ->
      let delta = left - right in
      let abs_delta = abs delta in
      acc + abs_delta
   ) 0 left_column right_column ;;

print_int solution ;;
