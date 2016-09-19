module type Sig = sig
  type t

  type config

  type query_error

  val make : config -> t

  val query : t -> Nnc_query.t -> unit -> (Nnc_event.t list, query_error) result
end
