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

module Int2Set = Set.Make(Int2) ;;



let starts =
   let rec iterate_row y x acc =
      if x >= width then acc
      else
         if lines_array.(y).[x] = '0' then iterate_row y (x+1) ((x, y) :: acc)
         else iterate_row y (x+1) acc
   in

   let rec iterate_rows y acc =
      if y >= height then acc
      else
         iterate_rows (y+1) (iterate_row y 0 acc)
   in

   iterate_rows 0 [] ;;


let result1 = 
   let rec travel x y target tops_set =
      let cond1 = x < 0 in
      let cond2 = x >= width in
      let cond3 = y < 0 in
      let cond4 = y >= height in
      if cond1 || cond2 || cond3 || cond4 then tops_set
      else
         let c = lines_array.(y).[x] in
         if c <> target then tops_set
         else if target = '9' then
            Int2Set.add (x, y) tops_set
         else
            let new_target = char_of_int ((int_of_char target) + 1) in
            tops_set
            |> travel (x-1) y new_target
            |> travel (x+1) y new_target
            |> travel x (y-1) new_target
            |> travel x (y+1) new_target
   in

   List.map (fun (x, y) -> Int2Set.cardinal (travel x y '0' Int2Set.empty)) starts
   |> List.fold_left (+) 0 ;;



let result2 = 
   let rec travel x y target acc =
      let cond1 = x < 0 in
      let cond2 = x >= width in
      let cond3 = y < 0 in
      let cond4 = y >= height in
      if cond1 || cond2 || cond3 || cond4 then acc
      else
         let c = lines_array.(y).[x] in
         if c <> target then acc
         else if target = '9' then acc + 1
         else
            let new_target = char_of_int ((int_of_char target) + 1) in
            acc
            |> travel (x-1) y new_target
            |> travel (x+1) y new_target
            |> travel x (y-1) new_target
            |> travel x (y+1) new_target
   in

   List.map (fun (x, y) -> travel x y '0' 0) starts
   |> List.fold_left (+) 0 ;;


Printf.printf "Silver: %d\n" result1 ;;
Printf.printf "Gold: %d\n" result2 ;;
