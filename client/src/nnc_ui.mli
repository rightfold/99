module Make (Client : Nnc_client.S) : sig
  val q : Client.t -> string -> unit -> unit
end
