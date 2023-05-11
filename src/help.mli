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
(**[perm_upgrade price item mouse hitbox purchased burger_stats item_stats state 
    price_list] Checks whether [mouse] has clicked on [hitbox] for the permanent 
    upgrades. If it has, then if the associated item's price is buyable for the 
    player (depending on if [burger_stats] has a burger count greater than or 
    equal to [price]), then [burger_stats], [item_stats], [price_list], and 
    [bps_mult] are updated appropriately to reflect the buying. Once this is 
    done, the item is longer purchaseable.*)

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
(** [facilitate_events golden_burger golden_burger_clicked golden_burger_hover
    mouse_point state burger_stats bps_mult cps_mult] enables the random event
    burger event spawning with the textures [golden_burger], 
    [golden_burger_clicked], and [golden_burger_hover] being use for the
    animation. [mouse_point] is used to check if the player is interacting with
    the burger. [bps_mult] and [cps_mult] are updated accordingly if the random
    event burger is clicked.*)

val text_draw : string -> int -> int -> Raylib.Color.t -> int -> unit
(** [text_draw text x y color size] draws text onto the GUI screen with the text
  in [text] with the top left corner at position [x] [y]. The color of the text
  is [color] and the size is [size]*)

val animate_random : unit -> unit
(** [animate_random] controls the animation of the text that appears when clicking
    a random burger. It places the text in the center of the screen and fades
    in, pauses for one second, and fades out.*)

val decrease_burger_spend : Config.information -> int -> unit
(**[decrease_burger_spend t price] decreases the burger count by [price] in a 
    given information type [t].*)

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
