open Nnc_std
module Client = Nnc_client_static
module Ui = Nnc_ui.Make (Client)

let () =
  let client = Client.create Nnc_event.examples in
  match Sys.argv with
  | [|_; "q"; query|] -> Ui.q client query ()
  | _ -> print_string "usage: nnc q <query>\n"
