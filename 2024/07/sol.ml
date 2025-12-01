let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let calibrations = 
   List.map (fun line ->
      let parts = String.split_on_char ':' line in
      match parts with
      | first :: second :: [] -> 
         let result = int_of_string first in
         let numbers_list = second 
            |> String.trim
            |> String.split_on_char ' ' in
            (* |> List.map int_of_string in // commented for faster part 2 *)
         (result, numbers_list)
      | _ -> failwith "Failed to parse line"
   ) lines ;;


let result1 =
   let is_calibration_valid (result, nlist) =
      let rec add_multiply result nlist acc =
         if acc > result then false
         else match nlist with
         | head :: tail -> 
            let n = int_of_string head in
            add_multiply result tail (acc+n) || add_multiply result tail (acc*n)
         | [] -> acc = result
      in
      add_multiply result nlist 0 in

   calibrations
   |> List.filter is_calibration_valid
   |> List.fold_left (fun acc (result, _) -> acc + result) 0 ;;



let result2 =
   let is_calibration_valid (result, nlist) =
      let append_str_to_num num s =
         let num_str = string_of_int num in
         num_str ^ s 
         |> int_of_string in

      let rec add_multiply result nlist acc =
         if acc > result then false
         else match nlist with
         | head :: tail -> 
            let n = int_of_string head in
               add_multiply result tail (acc+n) 
               || add_multiply result tail (acc*n)
               || add_multiply result tail (append_str_to_num acc head)
         | [] -> acc = result
      in
      add_multiply result nlist 0 in

   calibrations
   |> List.filter is_calibration_valid
   |> List.fold_left (fun acc (result, _) -> acc + result) 0 ;;


Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold : %d\n" result2 ;;
