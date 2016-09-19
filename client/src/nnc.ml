let q (query_str : string) () =
  match Nnc_query.parse query_str with
  | Some query -> ()
  | None -> ()

let usage () =
  print_string "usage: nnc q <query>\n"

let () =
  match Sys.argv with
  | [|_; "q"; query|] -> q query ()
  | _ -> usage ()
