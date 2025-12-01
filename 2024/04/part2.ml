let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let result2 =
   let width = String.length (List.hd lines) in
   let height = List.length lines in

   let check_diagonal1 l x y =
      let substring = 
         String.sub (List.nth l (y-1)) (x-1) 1 ^
         String.sub (List.nth l y) x 1 ^
         String.sub (List.nth l (y+1)) (x+1) 1 in
      if substring = "MAS" || substring = "SAM" then ( Printf.printf "hit diag1: %d %d %s\n" x y substring ; true)
      else false in

   let check_diagonal2 l x y =
      let substring = 
         String.sub (List.nth l (y-1)) (x+1) 1 ^
         String.sub (List.nth l y) x 1 ^
         String.sub (List.nth l (y+1)) (x-1) 1 in
      if substring = "MAS" || substring = "SAM" then ( Printf.printf "hit diag2: %d %d %s\n" x y substring ; true)
      else false in

   let rec transverse_grid l =
      let rec compute_row l x y =
         let constant_part = if check_diagonal1 l x y && check_diagonal2 l x y then 1 else 0 in
         let dynamic_part = if x+2 < width then compute_row l (x+1) y else 0 in
         constant_part + dynamic_part in

      let rec compute_rows l y =
         let this_row = compute_row l 1 y in
         let dynamic_part = if y+2 < height then compute_rows l (y+1) else 0 in
         this_row + dynamic_part in
      compute_rows l 1 in

   transverse_grid lines ;;
 
 Printf.printf "%d\n" result2 ;;
