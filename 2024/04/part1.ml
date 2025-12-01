let lines = In_channel.with_open_text "input.txt" In_channel.input_lines ;;

let result1 =
   let width = String.length (List.hd lines) in
   let height = List.length lines in

   let check_horizontal l x y =
      if x + 4 <= width then
         let substring = String.sub (List.nth l y) x 4 in
         if substring = "XMAS" || substring = "SAMX" then ( Printf.printf "hit horz: %d %d %s\n" x y substring ; 1)
         else 0
      else 0 in

   let check_vertical l x y =
      if y + 4 <= height then
         (let substring = 
            String.sub (List.nth l y) x 1 ^
            String.sub (List.nth l (y+1)) x 1 ^
            String.sub (List.nth l (y+2)) x 1 ^
            String.sub (List.nth l (y+3)) x 1 in
         if substring = "XMAS" || substring = "SAMX" then ( Printf.printf "hit vert: %d %d %s\n" x y substring ; 1)
         else 0)
      else 0 in

   let check_diagonal1 l x y =
      if y + 4 <= height && x + 4 <= width then
         (let substring = 
            String.sub (List.nth l y) x 1 ^
            String.sub (List.nth l (y+1)) (x+1) 1 ^
            String.sub (List.nth l (y+2)) (x+2) 1 ^
            String.sub (List.nth l (y+3)) (x+3) 1 in
         if substring = "XMAS" || substring = "SAMX" then ( Printf.printf "hit diag: %d %d %s\n" x y substring ; 1)
         else 0)
      else 0 in

   let check_diagonal2 l x y =
      if y + 4 <= height && x + 4 <= width then
         (let substring = 
            String.sub (List.nth l (y+3)) x 1 ^
            String.sub (List.nth l (y+2)) (x+1) 1 ^
            String.sub (List.nth l (y+1)) (x+2) 1 ^
            String.sub (List.nth l (y)) (x+3) 1 in
         if substring = "XMAS" || substring = "SAMX" then ( Printf.printf "hit diag: %d %d %s\n" x y substring ; 1)
         else 0)
      else 0 in

   let rec transverse_grid l =
      let rec compute_row l x y =
         let constant_part = check_horizontal l x y +
            check_vertical l x y +
            check_diagonal1 l x y + 
            check_diagonal2 l x y in
         let dynamic_part = if x+1 < width then compute_row l (x+1) y else 0 in
         constant_part + dynamic_part in

      let rec compute_rows l y =
         let this_row = compute_row l 0 y in
         let dynamic_part = if y+1 < height then compute_rows l (y+1) else 0 in
         this_row + dynamic_part in
      compute_rows l 0 in

   transverse_grid lines ;;

Printf.printf "%d\n" result1 ;;
