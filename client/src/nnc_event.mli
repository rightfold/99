type level =
  | Debug
  | Info
  | Notice
  | Warning
  | Error
  | Critical
  | Alert

val level_number : level -> int
