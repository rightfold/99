module Client = Nnc_client_cohttp_lwt.Make (Cohttp_lwt_unix.Client)

let q (query_str : string) () =
  match Nnc_query.parse query_str with
  | Some query ->
      begin
        let client = Client.make (Cohttp_lwt_unix.Client.default_ctx, "http://example.com") in
        match Client.query client query () with
        | Ok results ->
            print_int (List.length results);
            print_string "\n"
        | Error _ -> print_string "error\n"
      end
  | None -> ()

let usage () =
  print_string "usage: nnc q <query>\n"

let main () =
  match Sys.argv with
  | [|_; "q"; query|] -> q query ()
  | _ -> usage ()

let () = main ()
