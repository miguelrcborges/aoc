let input = String.trim (In_channel.with_open_text "input.txt" In_channel.input_all) ;;

let initial_list = input
   |> String.split_on_char ' '
   |> List.map int_of_string ;;


let print_list l = 
   let () = List.iter (Printf.printf "%d ") l in
   print_endline "\n" ;;


let number_of_digits n =
   let rec iter n acc =
      if n >= 10 then iter (n/10) (acc+1)
      else acc 
   in
   iter n 1 ;;

let ten_to_the_power_of n =
   let rec iter i n acc =
      if i >= n then acc
      else iter (i+1) n (acc*10)
   in
   iter 0 n 1 ;;


let blink_list l =
   let blink_element rev_output n =
      if n = 0 then 1 :: rev_output
      else 
         let n_digits = number_of_digits n in
         if n_digits mod 2 <> 0 then n * 2024 :: rev_output
         else
            let base_10 = ten_to_the_power_of (n_digits / 2) in
            n / base_10 :: n mod base_10 :: rev_output
   in
   List.fold_left blink_element [] l


let result1 =
   let times_to_blink = 25 in
   let rec blink_n_times times_to_blink blink_counter list_to_blink =
      if blink_counter >= times_to_blink then list_to_blink
      else 
         blink_n_times times_to_blink (blink_counter+1) (blink_list list_to_blink)
   in
   initial_list |> blink_n_times times_to_blink 0 |> List.length ;;



module IntMap = Map.Make(Int) ;;

let blink_map m =
   IntMap.fold (fun key value_count map ->
      let values_to_add = 
         if key = 0 then [1]
         else 
            let n_digits = number_of_digits key in
            if n_digits mod 2 <> 0 then [key * 2024]
            else
               let base_10 = ten_to_the_power_of (n_digits / 2) in
               [key / base_10; key mod base_10]
      in
      List.fold_left (fun map el -> 
         let count_to_set = match IntMap.find_opt el map with
         | Some y -> y + value_count
         | None -> value_count
         in
         IntMap.add el count_to_set map
      ) map values_to_add
   ) m IntMap.empty


let list_to_map l =
   List.fold_left (fun acc el -> 
      let v = match IntMap.find_opt el acc with
      | Some y -> y + 1
      | None -> 1
      in
      IntMap.add el v acc
   ) IntMap.empty l


let result2 =
   let times_to_blink = 75 in
   let rec blink_n_times times_to_blink blink_counter map_to_blink =
      if blink_counter >= times_to_blink then map_to_blink
      else 
         blink_n_times times_to_blink (blink_counter+1) (blink_map map_to_blink)
   in
   let final_map = initial_list
      |> list_to_map
      |> blink_n_times times_to_blink 0
   in
   IntMap.fold (fun k v acc -> acc + v) final_map 0 ;;

Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold: %d\n" result2 ;;
