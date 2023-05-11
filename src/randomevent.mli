(**Random event configuration*)

(**This module handles the logic for random event timing and burger gifting*)

val generate_timer : Config.random_stats -> unit
(** [generate_timer stats] uses [stats] to create a random timer amount to use
    for random event bonuses *)

val burger_gift : int -> int
(** [burger_gift burgers] uses [burgers] to generate a random amount of burgers
    between 10 and 30 percent to gift to the player*)
