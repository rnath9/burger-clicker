module Rand = Stdlib.Random
include Config

let generate_timer (stats : random_stats) =
  let time = (Rand.int 30 * 60) + stats.min_time in
  stats.timer <- -time

let burger_gift burgers = (Rand.int 3 + 1) * burgers / 10
