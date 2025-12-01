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
   

let move_robots_n_seconds (width, height) n ((robot_x, robot_y), (robot_dx, robot_dy)) =
   let robot_unmodded_x = robot_x + (robot_dx * n) in
   let robot_unmodded_y = robot_y + (robot_dy * n) in
   let robot_final_x = ((robot_unmodded_x mod width) + width) mod width in
   let robot_final_y = ((robot_unmodded_y mod height) + height) mod height in
   (robot_final_x, robot_final_y)



let result1 = 
   let width = 101 in
   let height = 103 in
   let seconds = 100 in
   let get_robots_per_quadrant (q1, q2, q3, q4) (rx, ry) =
      let middle_h = height / 2 in
      let middle_w = width / 2 in
      match (rx, ry) with
      | (x, y) when x < middle_w && y < middle_h -> (q1+1, q2, q3, q4)
      | (x, y) when x > middle_w && y < middle_h -> (q1, q2+1, q3, q4)
      | (x, y) when x < middle_w && y > middle_h -> (q1, q2, q3+1, q4)
      | (x, y) when x > middle_w && y > middle_h -> (q1, q2, q3, q4+1)
      | _ -> (q1, q2, q3, q4)
   in

   let (q1, q2, q3, q4) = robots
      |> List.map (move_robots_n_seconds (width, height) seconds)
      |> List.fold_left get_robots_per_quadrant (0, 0, 0, 0)
   in
   q1 * q2 * q3 * q4 ;;

Printf.printf "Silver: %d\n" result1 ;; 
