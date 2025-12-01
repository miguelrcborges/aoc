let input = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let parse_values s =
   let equal_index = String.index_from s 0 '=' in
   let strlen = String.length s in
   let substring = String.sub s (equal_index+1) (strlen-equal_index-1) in
   match substring 
      |> String.split_on_char ','
      |> List.map int_of_string 
   with
   | x :: y :: [] -> (x, y)
   | _ -> failwith "Failed to parse a robots values" ;;
   

let robots = 
   List.map (fun line -> match line
         |> String.split_on_char ' '
         |> List.map parse_values
      with
      | position :: velocity :: [] -> (position, velocity)
      | _ -> failwith "Failed to parse robots"
   ) input ;;
   

let move_robot (width, height) ((robot_x, robot_y), (robot_dx, robot_dy)) =
   let robot_unmodded_x = robot_x + robot_dx in
   let robot_unmodded_y = robot_y + robot_dy in
   let robot_final_x = ((robot_unmodded_x mod width) + width) mod width in
   let robot_final_y = ((robot_unmodded_y mod height) + height) mod height in
   ((robot_final_x, robot_final_y), (robot_dx, robot_dy))


let draw_robots width height robots_pos_list = 
   let arr = Array.make_matrix height width false in
   let rec iter_robots_list robot_head =
      match robot_head with 
      | ((x, y), (_, _)) :: tail ->
         let () = arr.(y).(x) <- true in
         iter_robots_list tail
      | [] -> ()
   in
   let () = iter_robots_list robots_pos_list in
   let rec draw_arr y x saw_long_row long_row_counter =
      if x >= width then 
         let () = print_char '\n' in
         draw_arr (y+1) 0 saw_long_row 0
      else if y >= height then 
         let () = print_char '\n' in
         saw_long_row
      else if arr.(y).(x) then 
         let () = print_char 'X' in
         let new_saw_long_row = saw_long_row || long_row_counter >= 8 in
         draw_arr y (x+1) new_saw_long_row (long_row_counter+1)
      else 
         let () = print_char ' ' in
         draw_arr y (x+1) saw_long_row 0
   in
   draw_arr 0 0 false 0 ;;


let rec draw_gens robots gen =
   let width = 101 in
   let height = 103 in
   let () = Printf.printf "Drawing gen %d\n\n" gen in
   let moved_robots = List.map (move_robot (width, height)) robots in
   let has_long_row = draw_robots width height moved_robots in
   let () = Out_channel.flush Out_channel.stdout in
   if has_long_row then
      match In_channel.input_line In_channel.stdin with
      | Some _ -> draw_gens moved_robots (gen+1)
      | None -> ()
   else draw_gens moved_robots (gen+1) ;;

draw_gens robots 1 ;;
