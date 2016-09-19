module type Sig = sig
  type t
  type config
  val make : config -> t
  val query : t -> Nnc_query.t -> unit -> Nnc_event.t list
end
