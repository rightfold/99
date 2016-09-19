type t =
  | And     of t * t
  | Or      of t * t
  | Not     of t
  | Compare of compare
and compare =
  | Eq of term * term
  | Ne of term * term
  | Lt of term * term
  | Le of term * term
  | Gt of term * term
  | Ge of term * term
and term =
  | Event_log
  | Event_timestamp
  | Event_host
  | Event_level
  | Event_field of string
  | String of string
  | Level of Nnc_event.level

let parse _ =
  None

let rec serialize a = serialize_t a
and serialize_t = function
  | And (a, b) -> `List [`String "and"; serialize a; serialize b]
  | Or  (a, b) -> `List [`String "or"; serialize a; serialize b]
  | Not a      -> `List [`String "not"; serialize a]
  | Compare a  -> serialize_compare a
and serialize_compare compare =
  let (fn, a_, b_) =
    match compare with
    | Eq (a, b) -> ("eq", a, b)
    | Ne (a, b) -> ("ne", a, b)
    | Lt (a, b) -> ("lt", a, b)
    | Le (a, b) -> ("le", a, b)
    | Gt (a, b) -> ("gt", a, b)
    | Ge (a, b) -> ("ge", a, b)
  in
  `List [`String fn; serialize_term a_; serialize_term b_]
and serialize_term = function
  | Event_log       -> `String "log"
  | Event_timestamp -> `String "timestamp"
  | Event_host      -> `String "host"
  | Event_level     -> `String "level"
  | Event_field a   -> `List [`String "field"; `String a]
  | String a        -> `List [`String "string"; `String a]
  | Level a         -> `List [`String "level"; `Int (Nnc_event.level_number a)]
