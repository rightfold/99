open Nnc_std
module Client = Nnc_client_static

let q (query_str : string) () : unit =
  match Nnc_query.parse query_str with
  | Some query ->
      let client = Client.make Nnc_event.examples in
      let events = Client.query client query () in
      let open Nnc_event in
      let rec print_events = function
        | [] -> ()
        | hd :: tl ->
            print_string (hd.log ^ "\t" ^ hd.host ^ "\n");
            print_events tl
      in print_events events
  | None -> ()

let usage () : unit =
  print_string "usage: nnc q <query>\n"

let main () : unit =
  match Sys.argv with
  | [|_; "q"; query|] -> q query ()
  | _ -> usage ()

let () = main ()
