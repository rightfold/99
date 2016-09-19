type t = unit

type level =
  | Debug
  | Info
  | Notice
  | Warning
  | Error
  | Critical
  | Alert

let level_number = function
  | Debug    -> 7
  | Info     -> 6
  | Notice   -> 5
  | Warning  -> 4
  | Error    -> 3
  | Critical -> 2
  | Alert    -> 1
