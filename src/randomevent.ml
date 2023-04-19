module Rand = Stdlib.Random
include Config

let generate_event (chance : int) =
  match Rand.int chance with
  | 1 -> "burger gift"
  | 2 -> "bps boost"
  | 3 -> "click power boost"
  | 4 -> "advice"
  | _ -> "nothing"

let generate_timer (stats : random_stats) =
  let time = (Rand.int 30 * 60) + stats.min_time in
  stats.timer <- -time

let burger_gift burgers = (Rand.int 3 + 1) * burgers / 10
