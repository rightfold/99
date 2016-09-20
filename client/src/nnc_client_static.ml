open Nnc_std

type t = Nnc_event.t list

type config = Nnc_event.t list

let make events = events

let query events _ = Eff.return events
