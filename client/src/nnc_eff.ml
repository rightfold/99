type 'a t = unit -> 'a

let create thk = thk

let unsafe_perform thk = thk ()

let map = `Define_using_bind

let return x () = x

let bind x k () =
  k (x ()) ()
