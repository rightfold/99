module type S = sig
  type t
  type config
  val create : config -> t
  val query : t -> Nnc_query.t -> unit -> Nnc_event.t list
end
