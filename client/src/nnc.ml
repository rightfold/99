open Nnc_std
open Eff.Monad.Monad_infix
(* module Client = Nnc_client_cohttp_lwt.Make (Cohttp_lwt_unix.Client) *)
module Client = Nnc_client_static

let q (query_str : string) : unit Eff.t =
  match Nnc_query.parse query_str with
  | Some query ->
      (*
      let client = Client.make { cohttp_ctx = Cohttp_lwt_unix.Client.default_ctx
                               ; endpoint = "http://example.com"
                               } in
      *)
      let client = Client.make [] in
      Client.query client query >>= fun events ->
      print_int (List.length events) >>= fun () ->
      print_string "\n"
  | None -> Nnc_eff.return ()

let usage : unit Eff.t =
  print_string "usage: nnc q <query>\n"

let main : unit Eff.t =
  Nnc_eff.create (fun () -> Sys.argv)
  >>= function
    | [|_; "q"; query|] -> q query
    | _ -> usage

let () = Nnc_eff.unsafe_perform main
