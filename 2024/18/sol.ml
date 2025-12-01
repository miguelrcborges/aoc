module Int2 = struct
  type t = int * int

  let compare (x0, y0) (x1, y1) =
     let xdiff = x0 - x1 in
     if xdiff <> 0 then xdiff else y0 - y1
end

module Int2Set = Set.Make(Int2)
module Int2Map = Map.Make(Int2)

let input = In_channel.with_open_text "input.txt" In_channel.input_lines ;;
let grid_final_pos = (70, 70) ;;
let part1_n_bytes = 1024 ;;

let corrupted_bytes_list = input
   |> List.map (fun l -> 
      let splits = l |> String.split_on_char ',' in
      match splits with
      | x :: y :: [] -> (int_of_string x, int_of_string y)
      | _ -> failwith "Failed to parse bytes list"
   )
;;

let rec get_set_of_list set max_n l =
   if max_n <= 0 then set
   else match l with
   | el :: tail -> get_set_of_list (Int2Set.add el set) (max_n - 1) tail
   | [] -> set
;;


let find_fastest_path corrupted_set (target_x, target_y) =
   let best_map = ref Int2Map.empty in
   let rec visit_tile current_count (current_x, current_y) = 
      let c1 = current_x < 0 in
      let c2 = current_x > target_x in
      let c3 = current_y < 0 in
      let c4 = current_y > target_y in
      if c1 || c2 || c3 || c4 then max_int
      else if Int2Set.mem (current_x, current_y) corrupted_set then max_int
      else if current_x == target_x && current_y == target_y then current_count
      else 
         let tile_best_value = match Int2Map.find_opt (current_x, current_y) !best_map with
            | Some v -> v
            | None -> max_int
         in
         if current_count >= tile_best_value then max_int
         else
            let () = best_map := Int2Map.add (current_x, current_y) current_count !best_map in
            let left = visit_tile (current_count+1) (current_x-1, current_y) in
            let right = visit_tile (current_count+1) (current_x+1, current_y) in
            let up = visit_tile (current_count+1) (current_x, current_y-1) in
            let down = visit_tile (current_count+1) (current_x, current_y+1) in
            min (min left right) (min up down)
   in
   visit_tile 0 (0, 0)
;;


let result1 = 
   let corrupted_set = get_set_of_list Int2Set.empty part1_n_bytes corrupted_bytes_list in
   find_fastest_path corrupted_set grid_final_pos
;;


let (result2_x, result2_y) =
   let rec binary_search max_valid min_unvalid =
      if max_valid + 1 >= min_unvalid then List.nth corrupted_bytes_list max_valid
      else
         let middle = ((max_valid + min_unvalid) / 2) in
         let corrupted_set = get_set_of_list Int2Set.empty middle corrupted_bytes_list in
         let fastest_path = find_fastest_path corrupted_set grid_final_pos in
         if fastest_path != max_int then binary_search middle min_unvalid
         else binary_search max_valid middle
   in
   binary_search part1_n_bytes (List.length corrupted_bytes_list)
;;


Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold: %d,%d\n" result2_x result2_y;;
