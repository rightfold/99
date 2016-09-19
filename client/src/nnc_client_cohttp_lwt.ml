open Core.Std

type 'cohttp_ctx config' =
  {cohttp_ctx: 'cohttp_ctx; endpoint: string}

module Query_error = struct
  type t =
    | Network_error of exn
    | Json_error of string
    | Structure_error

  let to_string = function
    | Network_error _ -> "network error"
    | Json_error e    -> e
    | Structure_error -> "bad JSON structure"
end

module Make (Cohttp : Cohttp_lwt.S.Client) : sig
  include Nnc_client.Sig
    with type config = Cohttp.ctx config'
    with type query_error = Query_error.t
end = struct
  type t = Cohttp.ctx config'
  type config = Cohttp.ctx config'
  type query_error = Query_error.t

  let make config = config

  let http_get ctx uri () =
    try Ok (Lwt_main.run (Cohttp.get ~ctx:ctx uri)) with
    | e -> Error (Query_error.Network_error e)

  let parse_json json =
    try Ok (Yojson.Basic.from_string json) with
    | Yojson.Json_error msg -> Error (Query_error.Json_error msg)

  let query config query () =
    let q = Yojson.to_string (Nnc_query.serialize query) in
    let uri = Uri.of_string config.endpoint in
    let uri = Uri.with_query' uri [("q", q)] in
    match http_get config.cohttp_ctx uri () with
    | Ok (res, res_body_stream) ->
        let res_body = Lwt_main.run (Cohttp_lwt_body.to_string res_body_stream) in
        Result.map (parse_json res_body) (fun _ -> [])
    | Error e -> Error e
end
