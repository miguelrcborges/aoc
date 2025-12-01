let input = String.trim (In_channel.with_open_text "input.txt" In_channel.input_all) ;;

type space =
  | Occupied of int
  | Free

let rec add_to_list times l v =
   if times = 0 then l
   else add_to_list (times-1) (v :: l) v ;;

let (initial_disk, occupied_blocks) =
   let rec read_input cursor current_id rev_list occupied_blocks =
      if cursor >= String.length input then (List.rev rev_list, occupied_blocks)
      else
         let n = (int_of_char input.[cursor] - int_of_char '0') in
         if cursor mod 2 = 0 then
            let new_list = add_to_list n rev_list (Occupied current_id) in
            read_input (cursor+1) (current_id+1) new_list (occupied_blocks+n)
         else
            let new_list = add_to_list n rev_list Free in
            read_input (cursor+1) (current_id) new_list occupied_blocks
   in
   read_input 0 0 [] 0 ;;

(*
let () = 
   let () = Printf.printf "%d occupied blocks.\n" occupied_blocks in
   let () = List.iter (fun el ->
      match el with
      | Occupied id -> Printf.printf "%d" id
      | Free -> Printf.printf "."
   ) initial_disk in
   print_endline ""
*)

let disk_part1 =
   let reverse_list = List.rev initial_disk in
   let rec generate_disk head tail remaining output = 
      if remaining = 0 then List.rev output
      else
         match head with
         | Occupied id :: hs -> generate_disk hs tail (remaining-1) (Occupied id :: output)
         | Free :: hs -> 
            let rec get_nonfree_tail l =
               match l with
               | Occupied _ :: ls -> l
               | Free :: ls -> get_nonfree_tail ls
               | [] -> failwith "Broken scenario 2"
            in
            let new_tail = get_nonfree_tail tail in
            generate_disk (List.tl head) (List.tl new_tail) (remaining-1) (List.hd new_tail :: output)
         | _ -> failwith "Broken scenario"
   in
   generate_disk initial_disk reverse_list occupied_blocks [] ;;


(*
let () = 
   let () = Printf.printf "%d occupied blocks.\n" occupied_blocks in
   let () = List.iter (fun el ->
      match el with
      | Occupied id -> Printf.printf "%d" id
      | Free -> Printf.printf "."
   ) disk_part1 in
   print_endline "" ;;
*)

let rec checksum l i acc =
   match l with
   | Occupied id :: ls -> checksum ls (i+1) (i*id + acc)
   | Free :: ls -> checksum ls (i+1) acc
   | [] -> acc

let result_part1 = checksum disk_part1 0 0 ;;


type space_chunk =
  | OccupiedChunk of int * int
  | FreeChunk of int

let initial_disk2 = 
   let rec read_input cursor current_id rev_list =
      if cursor >= String.length input then List.rev rev_list
      else
         let n = (int_of_char input.[cursor] - int_of_char '0') in
         if cursor mod 2 = 0 then read_input (cursor+1) (current_id+1) (OccupiedChunk (current_id, n) :: rev_list)
         else read_input (cursor+1) current_id (FreeChunk n :: rev_list)
   in
   read_input 0 0 [] ;;

let print_chunks l = 
   let () = List.iter (fun el ->
      match el with
      | OccupiedChunk (id, size) -> 
         let rec print_int_n id count =
            if count = 0 then ()
            else 
               let () = print_int id in
               print_int_n id (count-1)
         in
         print_int_n id size
      | FreeChunk size -> 
         let rec print_space count =
            if count = 0 then ()
            else 
               let () = print_char '.' in
               print_space (count-1)
         in
         print_space size
   ) l in
   print_endline "\n" ;;


(*
print_endline "Before:" ;;
print_chunks initial_disk2 ;; 
*)


module IntSet = Set.Make(Int)

let disk_part2_chunks =
   let reversed_list_only_chunks = List.fold_left (fun acc el ->
      match el with
      | OccupiedChunk (id, size) -> (id, size) :: acc
      | FreeChunk _ -> acc
   ) [] initial_disk2 in
   
   let rec replace_chunk_with_free l target_id = 
      match l with
      | FreeChunk (size) :: tail -> FreeChunk (size) :: replace_chunk_with_free tail target_id
      | OccupiedChunk (chunk_id, size) :: tail -> 
         if chunk_id = target_id then FreeChunk (size) :: tail 
         else OccupiedChunk (chunk_id, size) :: replace_chunk_with_free tail target_id
      | [] -> failwith "id not found"
   in

   let refrag_step disk_chunks (to_move_chunk_id, to_move_chunk_size) =
      let rec check_and_insert disk_chunks_cursor last_seen_id output =
         if last_seen_id = to_move_chunk_id then 
            List.rev output @ disk_chunks_cursor
         else
            match disk_chunks_cursor with
            | OccupiedChunk (id, size) :: tail -> check_and_insert tail id (OccupiedChunk (id, size) :: output)
            | FreeChunk size :: tail ->
               if size < to_move_chunk_size then check_and_insert tail last_seen_id (FreeChunk size :: output)
               else 
                  let head = List.rev (FreeChunk (size - to_move_chunk_size) :: OccupiedChunk (to_move_chunk_id, to_move_chunk_size) :: output) in
                  let filtered_tail = replace_chunk_with_free tail to_move_chunk_id in
                  head @ filtered_tail
            | [] -> failwith "Something wrong"
      in
      check_and_insert disk_chunks 0 []
   in

   List.fold_left refrag_step initial_disk2 reversed_list_only_chunks ;;


(*
print_endline "After:" ;;
print_chunks disk_part2_chunks ;;
*)


let disk_part2 = 
   List.fold_left (fun output el ->
      match el with
      | OccupiedChunk (id, size) -> add_to_list size output (Occupied id)
      | FreeChunk size -> add_to_list size output Free
   ) [] disk_part2_chunks
   |> List.rev
let result_part2 = checksum disk_part2 0 0 ;;

Printf.printf "Silver: %d\n" result_part1 ;;
Printf.printf "Gold: %d\n" result_part2 ;;
