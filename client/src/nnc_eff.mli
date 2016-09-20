type 'a t

val create : (unit -> 'a) -> 'a t

val unsafe_perform : 'a t -> 'a

val map : [`Custom of 'a t -> f:('a -> 'b) -> 'b t | `Define_using_bind]

val return : 'a -> 'a t

val bind : 'a t -> ('a -> 'b t) -> 'b t
