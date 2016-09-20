module Make (Client : Nnc_client.S) = struct
  let q client query_str () =
    match Nnc_query.parse query_str with
    | Some query ->
        let events = Client.query client query () in
        let open Nnc_event in
        let rec print_events = function
          | [] -> ()
          | hd :: tl ->
              print_string (hd.log ^ "\t" ^ hd.host ^ "\n");
              print_events tl
        in print_events events
    | None -> ()
end
