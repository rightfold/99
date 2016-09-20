open Nnc_std

type t =
  { log       : string
  ; timestamp : Time.t
  ; host      : string
  ; level     : level
  ; fields    : string StringMap.t
  }
and level = [
  | `Debug
  | `Info
  | `Notice
  | `Warning
  | `Error
  | `Critical
  | `Alert
]

let level_number : level -> int = function
  | `Debug    -> 7
  | `Info     -> 6
  | `Notice   -> 5
  | `Warning  -> 4
  | `Error    -> 3
  | `Critical -> 2
  | `Alert    -> 1

let examples : t list = [
  {log = "foo"; timestamp = Time.epoch; host = "example.com"; level = `Info; fields = StringMap.singleton "msg" "boot"};
  {log = "bar"; timestamp = Time.epoch; host = "example.com"; level = `Error; fields = StringMap.singleton "msg" "oops"};
]
