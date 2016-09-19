module Make (Cohttp : Cohttp_lwt.S.Client) : sig
  include Nnc_client.Sig
    with type config = Cohttp.ctx * string
    with type query_error = unit
end = struct
  type t = Cohttp.ctx * string

  type config = Cohttp.ctx * string

  type query_error = unit

  let make config = config

  let http_get ctx uri () =
    try Ok (Lwt_main.run (Cohttp.get ~ctx:ctx uri)) with
    | _ -> Error ()

  let query (ctx, endpoint) query () =
    let q = Yojson.to_string (Nnc_query.serialize query) in
    let uri = Uri.of_string endpoint in
    let uri = Uri.with_query' uri [("q", q)] in
    match http_get ctx uri () with
    | Ok (res, res_body) -> Ok []
    | Error e -> Error e
end
