let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let lines_array = Array.of_list lines ;;

let width = String.length lines_array.(0) ;;
let height = Array.length lines_array ;;

module Int2 = struct
  type t = int * int

  let compare (x0, y0) (x1, y1) =
     let xdiff = x0 - x1 in
     if xdiff <> 0 then xdiff else y0 - y1
end ;;

module CharMap = Map.Make(Char) ;;
module Int2Set = Set.Make(Int2) ;;

let result1 =
   let check_antinodes (x1, y1) (x2, y2) antinodes =
      let dx = x2 - x1 in
      let dy = y2 - y1 in
      let x3 = x1 - dx in
      let y3 = y1 - dy in
      let x4 = x2 + dx in
      let y4 = y2 + dy in
      let x3_valid = x3 >= 0 && x3 < width in
      let y3_valid = y3 >= 0 && y3 < height in
      let x4_valid = x4 >= 0 && x4 < width in
      let y4_valid = y4 >= 0 && y4 < height in
      (* let () = Printf.printf "%d %d %d %d (%d): %d %d\n" x1 y1 x2 y2 (Int2Set.cardinal antinodes) x3 y3 in *)
      let tmp1 = 
         if x3_valid && y3_valid then Int2Set.add (x3, y3) antinodes
         else antinodes in
      (* let () = Printf.printf "%d %d %d %d (%d): %d %d\n" x1 y1 x2 y2 (Int2Set.cardinal tmp1) x4 y4 in *)
      let tmp2 = 
         if x4_valid && y4_valid then Int2Set.add (x4, y4) tmp1
         else tmp1 in
      tmp2
   in

   let rec iterate_row y x antinodes visited_map =
      if x >= width then (antinodes, visited_map)
      else if lines_array.(y).[x] = '.' then 
         iterate_row y (x+1) antinodes visited_map
      else
         let c = lines_array.(y).[x] in
         let previous_seen = match CharMap.find_opt c visited_map with
         | Some l -> l
         | None -> []
         in
         let new_map = CharMap.add c ((x, y) :: previous_seen) visited_map in
         let new_set = List.fold_left (fun current_set p ->
             check_antinodes p (x,y) current_set 
         ) antinodes previous_seen in
         iterate_row y (x+1) new_set new_map 
   in

   let rec iterate_rows y antinodes visited_map =
      if y >= height then antinodes
      else 
         let (new_acc, new_map) = iterate_row y 0 antinodes visited_map in
         iterate_rows (y+1) new_acc new_map
   in

   iterate_rows 0 Int2Set.empty CharMap.empty 
   |> Int2Set.cardinal ;;



let result2 =
   let check_antinodes (x1, y1) (x2, y2) antinodes =
      let dx = x2 - x1 in
      let dy = y2 - y1 in

      let rec add_all_altinodes x y dx dy antinodes =
         let x_valid = x >= 0 && x < width in
         let y_valid = y >= 0 && y < height in
         if x_valid && y_valid then
            let new_set = Int2Set.add (x, y) antinodes in
            (* let () = Printf.printf "%d: %d %d\n" (Int2Set.cardinal new_set) x y in *)
            add_all_altinodes (x+dx) (y+dy) dx dy new_set
         else antinodes
      in

      antinodes 
      |> add_all_altinodes x2 y2 dx dy
      |> add_all_altinodes x1 y1 (-dx) (-dy)
   in

   let rec iterate_row y x antinodes visited_map =
      if x >= width then (antinodes, visited_map)
      else if lines_array.(y).[x] = '.' then 
         iterate_row y (x+1) antinodes visited_map
      else
         let c = lines_array.(y).[x] in
         let previous_seen = match CharMap.find_opt c visited_map with
         | Some l -> l
         | None -> []
         in
         let new_map = CharMap.add c ((x, y) :: previous_seen) visited_map in
         let new_set = List.fold_left (fun current_set p ->
             check_antinodes p (x,y) current_set 
         ) antinodes previous_seen in
         iterate_row y (x+1) new_set new_map 
   in

   let rec iterate_rows y antinodes visited_map =
      if y >= height then antinodes
      else 
         let (new_acc, new_map) = iterate_row y 0 antinodes visited_map in
         iterate_rows (y+1) new_acc new_map
   in

   iterate_rows 0 Int2Set.empty CharMap.empty 
   |> Int2Set.cardinal ;;


Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold: %d\n" result2 ;;
