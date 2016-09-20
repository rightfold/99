open Nnc_std

type 'cohttp_ctx config' =
  {cohttp_ctx: 'cohttp_ctx; endpoint: string}

module Make (Cohttp : Cohttp_lwt.S.Client) : sig
  include Nnc_client.S
    with type config = Cohttp.ctx config'
end = struct
  type t = Cohttp.ctx config'
  type config = Cohttp.ctx config'

  let make config = config

  let query config query = Eff.create @@ fun () ->
    let q = Yojson.to_string (Nnc_query.serialize query) in
    let uri = Uri.of_string config.endpoint in
    let uri = Uri.with_query' uri [("q", q)] in
    let (res, res_body_stream) = Lwt_main.run (Cohttp.get ~ctx:config.cohttp_ctx uri) in
    let res_body = Lwt_main.run (Cohttp_lwt_body.to_string res_body_stream) in
    let json = Yojson.Basic.from_string res_body in
    []
end
