open Core.Std

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

module Parse_utils : sig
  open Sexplib.Sexp
  val parse_sexp : string -> t option
  val binary : (t -> 'a option) -> t -> t -> ('a -> 'a -> 'b) -> 'b option
end = struct
  open Option.Monad_infix
  let parse_sexp text =
    try Some (Sexplib.Sexp.of_string text) with
    | Failure _ -> None
  let binary parse a b combine =
    parse a >>= fun a ->
    parse b >>= fun b ->
    Some (combine a b)
end

let parse text =
  let open Sexplib.Sexp in
  let open Parse_utils in
  let rec t_of_sexp = function
    | List [Atom "and"; a; b] -> binary t_of_sexp a b (fun a b -> And (a, b))
    | List [Atom "or";  a; b] -> binary t_of_sexp a b (fun a b -> Or  (a, b))
    | List [Atom "not"; a]    -> Option.map (t_of_sexp a) (fun a -> Not a)
    | other -> Option.map (compare_of_sexp other) (fun a -> Compare a)
  and compare_of_sexp = function
    | List [Atom "eq"; a; b] -> binary term_of_sexp a b (fun a b -> Eq (a, b))
    | List [Atom "ne"; a; b] -> binary term_of_sexp a b (fun a b -> Ne (a, b))
    | List [Atom "lt"; a; b] -> binary term_of_sexp a b (fun a b -> Lt (a, b))
    | List [Atom "le"; a; b] -> binary term_of_sexp a b (fun a b -> Le (a, b))
    | List [Atom "gt"; a; b] -> binary term_of_sexp a b (fun a b -> Gt (a, b))
    | List [Atom "ge"; a; b] -> binary term_of_sexp a b (fun a b -> Ge (a, b))
    | _ -> None
  and term_of_sexp = function
    | Atom "$log"       -> Some Event_log
    | Atom "$timestamp" -> Some Event_timestamp
    | Atom "$host"      -> Some Event_host
    | Atom "$level"     -> Some Event_level
    | Atom "#debug"     -> Some (Level Nnc_event.Debug)
    | Atom "#info"      -> Some (Level Nnc_event.Info)
    | Atom "#notice"    -> Some (Level Nnc_event.Notice)
    | Atom "#warning"   -> Some (Level Nnc_event.Warning)
    | Atom "#error"     -> Some (Level Nnc_event.Error)
    | Atom "#critical"  -> Some (Level Nnc_event.Critical)
    | Atom "#alert"     -> Some (Level Nnc_event.Alert)
    | Atom s ->
        if String.is_prefix s "@"
        then Some (Event_field (String.drop_prefix s 1))
        else Some (String s)
    | _ -> None
  in
  Option.bind (parse_sexp text) t_of_sexp

let rec serialize a = serialize_t a
and serialize_t = function
  | And (a, b) -> `List [`String "and"; serialize a; serialize b]
  | Or  (a, b) -> `List [`String "or";  serialize a; serialize b]
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
