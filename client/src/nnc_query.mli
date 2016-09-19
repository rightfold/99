type t

val parse : string -> t option

val serialize : t -> Yojson.json
