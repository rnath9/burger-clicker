type information = { mutable burgers : int }

let init = { burgers = 0 }
let increment_burger t = t.burgers <- t.burgers + 1
