let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

module Int2 = struct
  type t = int * int

  let compare (x0, y0) (x1, y1) =
     let xdiff = x0 - x1 in
     if xdiff <> 0 then xdiff else y0 - y1
end

module Int2Set = Set.Make(Int2)

let width = String.length (List.hd lines) ;;
let heigth = List.length lines ;;

let (obstacles, guard_pos) = 
   let rec iterate_row obstacles_set guard_pos line line_number line_pos =
      if line_pos >= width then (obstacles_set, guard_pos)
      else 
         let c = line.[line_pos] in
         match c with
         | '#' -> 
            let new_obstacles_set = Int2Set.add (line_pos, line_number) obstacles_set in
            iterate_row new_obstacles_set guard_pos line line_number (line_pos+1)
         | '^' ->
            iterate_row obstacles_set (line_pos, line_number) line line_number (line_pos+1)
         | _ -> 
            iterate_row obstacles_set guard_pos line line_number (line_pos+1)
   in

   let rec iterate_rows obstacles_set guard_pos lines line_number =
      match lines with
      | current :: tail ->
            let (new_obstacles_set, new_guard_pos) = 
               iterate_row obstacles_set guard_pos current line_number 0 in
            iterate_rows new_obstacles_set new_guard_pos tail (line_number+1)
      | _ -> (obstacles_set, guard_pos)
   in

   iterate_rows Int2Set.empty (0, 0) lines 0 ;;


let result1 = 
   let rec transverse (guard_x, guard_y) guard_dir visited =
      if guard_x < 0 || guard_x >= width || guard_y < 0 || guard_y >= heigth then
         Int2Set.cardinal visited
      else
         let new_set = Int2Set.add (guard_x, guard_y) visited in
         match guard_dir with
         | 0 ->
            let new_guard_pos = (guard_x, guard_y-1) in
            let faces_obstacle = Int2Set.mem new_guard_pos obstacles in
            if faces_obstacle then transverse (guard_x, guard_y) 1 new_set
            else transverse new_guard_pos guard_dir new_set
         | 1 ->
            let new_guard_pos = (guard_x+1, guard_y) in
            let faces_obstacle = Int2Set.mem new_guard_pos obstacles in
            if faces_obstacle then transverse (guard_x, guard_y) 2 new_set
            else transverse new_guard_pos guard_dir new_set
         | 2 ->
            let new_guard_pos = (guard_x, guard_y+1) in
            let faces_obstacle = Int2Set.mem new_guard_pos obstacles in
            if faces_obstacle then transverse (guard_x, guard_y) 3 new_set
            else transverse new_guard_pos guard_dir new_set
         | 3 ->
            let new_guard_pos = (guard_x-1, guard_y) in
            let faces_obstacle = Int2Set.mem new_guard_pos obstacles in
            if faces_obstacle then transverse (guard_x, guard_y) 0 new_set
            else transverse new_guard_pos guard_dir new_set
         | _ -> failwith "Invalid direction"
   in
   
   transverse guard_pos 0 Int2Set.empty ;;

Printf.printf "Silver: %d\n" result1 ;;

module Int3 = struct
  type t = int * int * int

  let compare (x0, y0, z0) (x1, y1, z1) =
     let xdiff = x0 - x1 in
     if xdiff <> 0 then xdiff 
     else 
        let ydiff = y0 - y1 in
        if ydiff <> 0 then ydiff else z0 - z1
end

module Int3Set = Set.Make(Int3)


let result2 = 
   let rec gets_stuck (guard_x, guard_y) guard_dir faced_obstacles obstacles =
      if guard_x < 0 || guard_x >= width || guard_y < 0 || guard_y >= heigth then
         false
      else
         match guard_dir with
         | 0 ->
            let (nx, ny) = (guard_x, guard_y-1) in
            let faces_obstacle = Int2Set.mem (nx, ny) obstacles in
            if faces_obstacle then 
               let is_stuck = Int3Set.mem (nx, ny, guard_dir) faced_obstacles in
               (if is_stuck then true
               else
                  let new_set = Int3Set.add (nx, ny, guard_dir) faced_obstacles in
                  gets_stuck (guard_x, guard_y) 1 new_set obstacles)
            else gets_stuck (nx, ny) guard_dir faced_obstacles obstacles
         | 1 ->
            let (nx, ny) = (guard_x+1, guard_y) in
            let faces_obstacle = Int2Set.mem (nx, ny) obstacles in
            if faces_obstacle then 
               let is_stuck = Int3Set.mem (nx, ny, guard_dir) faced_obstacles in
               (if is_stuck then true
               else
                  let new_set = Int3Set.add (nx, ny, guard_dir) faced_obstacles in
                  gets_stuck (guard_x, guard_y) 2 new_set obstacles)
            else gets_stuck (nx, ny) guard_dir faced_obstacles obstacles
         | 2 ->
            let (nx, ny) = (guard_x, guard_y+1) in
            let faces_obstacle = Int2Set.mem (nx, ny) obstacles in
            if faces_obstacle then 
               let is_stuck = Int3Set.mem (nx, ny, guard_dir) faced_obstacles in
               (if is_stuck then true
               else
                  let new_set = Int3Set.add (nx, ny, guard_dir) faced_obstacles in
                  gets_stuck (guard_x, guard_y) 3 new_set obstacles)
            else gets_stuck (nx, ny) guard_dir faced_obstacles obstacles
         | 3 ->
            let (nx, ny) = (guard_x-1, guard_y) in
            let faces_obstacle = Int2Set.mem (nx, ny) obstacles in
            if faces_obstacle then 
               let is_stuck = Int3Set.mem (nx, ny, guard_dir) faced_obstacles in
               (if is_stuck then true
               else
                  let new_set = Int3Set.add (nx, ny, guard_dir) faced_obstacles in
                  gets_stuck (guard_x, guard_y) 0 new_set obstacles)
            else gets_stuck (nx, ny) guard_dir faced_obstacles obstacles
         | _ -> failwith "Invalid direction"
   in

   let rec bruteforce_row y x count =
      if x >= width then count
      else
         let set_to_test = Int2Set.add (x, y) obstacles in
         let new_count = 
            if gets_stuck guard_pos 0 Int3Set.empty set_to_test then
               count + 1
            else count
         in
         bruteforce_row y (x+1) new_count 
   in
   
   let rec bruteforce_rows y count =
      if y >= heigth then count
      else
         bruteforce_rows (y+1) (bruteforce_row y 0 count) 
   in

   bruteforce_rows 0 0 ;;

Printf.printf "Gold: %d\n" result2 ;;
