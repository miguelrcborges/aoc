let input = String.trim (In_channel.with_open_text "input.txt" In_channel.input_all) 
;;


type tile =
   | Wall
   | Free
;;


type direction =
   | East
   | North
   | South
   | West
;;

let direction_to_string d =
   match d with
   | East -> "East"
   | North -> "North"
   | South -> "South"
   | West -> "West"
;;

let print_grid grid =
   Array.iter (fun line ->
      let () = Array.iter (fun tile ->
         match tile with
         | Wall -> print_char '#'
         | Free -> print_char '.'
      ) line in
      print_char '\n'
   ) grid
;;


let (grid, initial_pos, target_pos) = 
   let rec parse_input final_list line_list camel_pos target_pos s_index =
      if s_index >= String.length input then
         let line_arr = line_list |> List.rev |> Array.of_list in
         let final_array = (line_arr :: final_list) |> List.rev |> Array.of_list in
         (final_array, camel_pos, target_pos)
      else match input.[s_index] with
      | '#' -> parse_input final_list (Wall :: line_list) camel_pos target_pos (s_index+1)
      | '.' -> parse_input final_list (Free :: line_list) camel_pos target_pos (s_index+1)
      | 'S' -> parse_input final_list (Free :: line_list) ((List.length line_list), (List.length final_list)) target_pos (s_index+1)
      | 'E' -> parse_input final_list (Free :: line_list) camel_pos ((List.length line_list), (List.length final_list)) (s_index+1)
      | '\n' -> 
         let line_arr = line_list |> List.rev |> Array.of_list in
         parse_input (line_arr :: final_list) [] camel_pos target_pos (s_index+1)
      | _ -> parse_input final_list line_list camel_pos target_pos (s_index+1)
   in
   parse_input [] [] (0, 0) (0, 0) 0
;;


module Int2 = struct
  type t = int * int

  let compare (x0, y0) (x1, y1) =
     let xdiff = x0 - x1 in
     if xdiff <> 0 then xdiff 
     else y0 - y1
end

module Int2Set = Set.Make(Int2)
module Int2Map = Map.Make(Int2)



let result1 =
   let (tx, ty) = target_pos in
   let best_map = ref Int2Map.empty in
   let rec travel (cx, cy) last_dir visited_set current_score min_score =
      if grid.(cy).(cx) = Wall then min_score
      else 
         let v = match Int2Map.find_opt (cx, cy) !best_map with
            | Some v -> v
            | None -> max_int
         in
         if v <= current_score then min_score
      else if Int2Set.mem (cx, cy) visited_set then min_score
      else if cx = tx && cy = ty then min min_score current_score
      else
         let new_set = Int2Set.add (cx, cy) visited_set in
         let () = best_map := Int2Map.add (cx, cy) current_score !best_map in
         match last_dir with
            | East -> 
               min_score
               |> travel (cx, cy-1) North new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1)
            | North -> 
               min_score
               |> travel (cx-1, cy) West new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1001)
               |> travel (cx, cy-1) North new_set (current_score+1)
            | West ->
               min_score
               |> travel (cx, cy-1) North new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1001)
               |> travel (cx-1, cy) West new_set (current_score+1)
            | South ->
               min_score
               |> travel (cx-1, cy) West new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1)
   in
   travel initial_pos East Int2Set.empty 0 max_int
;;


let (result1, result2) =
   let (tx, ty) = target_pos in
   let best_map = ref Int2Map.empty in
   let rec travel (cx, cy) last_dir visited_set current_score (min_score, best_tiles) =
      if grid.(cy).(cx) = Wall then (min_score, best_tiles)
      else 
         let v = match Int2Map.find_opt (cx, cy) !best_map with
            | Some v -> v + 1000
            | None -> max_int
         in
         if v < current_score then (min_score, best_tiles)
      else if Int2Set.mem (cx, cy) visited_set then (min_score, best_tiles)
      else if cx = tx && cy = ty then 
         if min_score > current_score then (current_score, visited_set)
         else if min_score = current_score then (current_score, Int2Set.union best_tiles visited_set)
         else (min_score, best_tiles)
      else
         let new_set = Int2Set.add (cx, cy) visited_set in
         let () = best_map := Int2Map.add (cx, cy) current_score !best_map in
         match last_dir with
            | East -> 
               (min_score, best_tiles)
               |> travel (cx, cy-1) North new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1)
            | North -> 
               (min_score, best_tiles)
               |> travel (cx-1, cy) West new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1001)
               |> travel (cx, cy-1) North new_set (current_score+1)
            | West ->
               (min_score, best_tiles)
               |> travel (cx, cy-1) North new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1001)
               |> travel (cx-1, cy) West new_set (current_score+1)
            | South ->
               (min_score, best_tiles)
               |> travel (cx-1, cy) West new_set (current_score+1001)
               |> travel (cx+1, cy) East new_set (current_score+1001)
               |> travel (cx, cy+1) South new_set (current_score+1)
   in
   let (score, best_tiles) = travel initial_pos East Int2Set.empty 0 (max_int, Int2Set.empty) in
   (score, Int2Set.cardinal best_tiles + 1)
;;



Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold: %d\n" result2 ;;
