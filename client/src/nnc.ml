module Client = Nnc_client_cohttp_lwt.Make (Cohttp_lwt_unix.Client)

let q (query_str : string) () =
  match Nnc_query.parse query_str with
  | Some query ->
      begin
        let client = Client.make { cohttp_ctx = Cohttp_lwt_unix.Client.default_ctx
                                 ; endpoint = "http://example.com"
                                 } in
        let events = Client.query client query () in
        print_int (List.length events);
        print_string "\n"
      end
  | None -> ()

let usage () =
  print_string "usage: nnc q <query>\n"

let main () =
  match Sys.argv with
  | [|_; "q"; query|] -> q query ()
  | _ -> usage ()

let () = main ()
