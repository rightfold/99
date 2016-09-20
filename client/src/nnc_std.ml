include Core.Std
module Eff = struct
  include Nnc_eff
  module Monad = Monad.Make (Nnc_eff)
end
let print_int (x : int) : unit Eff.t = Eff.create @@ fun () -> Caml.print_int x
let print_string (x : string) : unit Eff.t = Eff.create @@ fun () -> Caml.print_string x
