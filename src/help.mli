(**The library of helper functions*)

(**[Help] contains the majority of our helper functions, making use of [Helper.Config]*)

val burger_init : Config.information
(** [burger_init] initializes the game with 0 burgers, 0 burgers per second, 
    and 1 burger per click.*)

val increment_burger_click : Config.information -> unit
(** [increment_burger_click] increments the burger count by one click 
in a given information type [t].*)

val increment_burger_bps : Config.information -> int -> unit
(**[increment_burger_bps t] increments the total burgers by the burger per second 
divided by [frames_per_update] in a given information type [t]*)

val truncate : float -> string list -> string
(**[truncate num suffix] handles the logic for representing a digit on the top of
    the screen for user view.*)

val shop :
  int ->
  string ->
  Raylib.Vector2.t ->
  Raylib.Rectangle.t ->
  Config.information ->
  Config.powerups ->
  int ref ->
  Config.prices ->
  int ref ->
  unit
(**[shop price item mouse hitbox burger_stats item_stats state price_list bps_mult]
    Checks whether [mouse] has clicked on [hitbox]. If it has, then
    if the associated item's price is buyable for the player (depending on if 
    [burger_stats] has a burger count greater than or equal to [price]), then 
    [burger_stats], [item_stats], [price_list], and [bps_mult] are updated 
    appropriately to reflect the buying.*)

val perm_upgrade :
  int ->
  string ->
  Raylib.Vector2.t ->
  Raylib.Rectangle.t ->
  int ->
  Config.information ->
  Config.powerups ->
  int ref ->
  Config.prices ->
  unit
(**[perm_upgrade price item mouse hitbox purchased ]*)

val facilitate_achievements :
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Config.information ->
  Config.powerups ->
  unit
(** placeholder comment*)

val facilitate_events :
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Texture.t ->
  Raylib.Vector2.t ->
  int ref ->
  Config.information ->
  int ref ->
  int ref ->
  unit
(** placeholder comment*)

val text_draw : string -> int -> int -> Raylib.Color.t -> int -> unit
(** placeholder comment*)

val animate_random : unit -> unit
(**placeholder comment*)

val decrease_burger_spend : Config.information -> int -> unit
(**placeholder comment*)

val increment_bps : Config.information -> string -> int ref -> unit
(**[increment_bps t item] increments the burgers per second depending on [item] in a 
    given information type [t].*)

val increment_click_power : Config.information -> int -> unit
(**[increment_click_power t mult] increments the amount of burgers the user gets in one
    click by a multiplier [mult] in a given information type [t]*)

val increment_item : Config.powerups -> string -> Config.prices -> unit
(**[increment_item p item] updates the amount of an item [item] in [p] and records its new 
    associated price in a mutable record [pr]. Example: if a spatula is bought, 
    then [increment_item p "spatula" pr] would increment [p.spatula] by 1, and update [pr.spatula_price]
    using [increase_price]*)

val animate_text : Config.animation -> string -> unit
