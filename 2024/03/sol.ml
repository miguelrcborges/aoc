#load "str.cma"

let input = In_channel.with_open_text "input.txt" In_channel.input_all;;

let result_part1 =
   let regex = Str.regexp "mul([0-9]+,[0-9]+)" in
   let rec get_all_matches s r i =
      let end_pos = 
         try Some (Str.search_forward r s i) with
            Not_found -> None in
      match end_pos with
      | Some x -> 
         let matched = Str.matched_string s in
         matched :: get_all_matches s r (x+1)
      | None -> [] in
   let matches = get_all_matches input regex 0 in
   let only_numbers = List.map (fun m -> 
      let m_len = String.length m in
      let slice_len = m_len - 5 in
      let slice = String.sub m 4 slice_len in
      let numbers_str = String.split_on_char ',' slice in
      List.map int_of_string numbers_str
   ) matches in
   let products = List.map (fun op -> 
      match op with
      | el1 :: el2 :: [] -> el1 * el2
      | _ -> failwith "Failed to parse OP properly."
   ) only_numbers in
   List.fold_left (fun acc el -> acc + el) 0 products ;;

Printf.printf "%d\n" result_part1 ;;


let result_part2 =
   let regex = Str.regexp "mul([0-9]+,[0-9]+)\\|do()\\|don't()" in
   let rec get_all_matches s r i =
      let end_pos = 
         try Some (Str.search_forward r s i) with
            Not_found -> None in
      match end_pos with
      | Some x -> 
         let matched = Str.matched_string s in
         matched :: get_all_matches s r (x+1)
      | None -> [] in
   let matches = get_all_matches input regex 0 in
   let rec process_list matches enabled = 
      match matches with
      | m :: ms ->
         if m = "do()" then
            process_list ms true
         else if m = "don't()" || (not enabled) then
            process_list ms false
         else 
            let m_len = String.length m in
            let slice_len = m_len - 5 in
            let slice = String.sub m 4 slice_len in
            let numbers_str = String.split_on_char ',' slice in
            let numbers = List.map int_of_string numbers_str in
            (match numbers with
            | el1 :: el2 :: [] -> el1 * el2 + process_list ms enabled
            | _ -> failwith "Failed to parse OP properly.")
      | _ -> 0
      in
   process_list matches true ;;

Printf.printf "%d\n" result_part2 ;;
