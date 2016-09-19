let q (query_str : string) () =
  match Nnc_query.parse query_str with
  | Some query ->
      print_string (Yojson.to_string (Nnc_query.serialize query));
      print_string "\n"
  | None -> ()

let usage () =
  print_string "usage: nnc q <query>\n"

let () =
  match Sys.argv with
  | [|_; "q"; query|] -> q query ()
  | _ -> usage ()
