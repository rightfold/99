open Nnc_std

module type S = sig
  type t
  type config
  val make : config -> t
  val query : t -> Nnc_query.t -> Nnc_event.t list Eff.t
end
