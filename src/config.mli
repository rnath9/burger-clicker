(**Configuration of types and starting values used throughout the game*)

(**[Config] was designed to store most of our types and values that we make use
    of throughout the game. This module is frequently used by other modules to get
    common values that are needed, like hitboxes or game states.*)

type information = {
  mutable burgers : float;
  mutable bps : int;
  mutable click_power : int;
}

type random_stats = {
  mutable chance : int;
  mutable timer : int;
  mutable min_time : int;
}

type powerups = {
  mutable sauce : int;
  mutable secret_sauce : int;
  mutable spatula : int;
  mutable grilling_dad : int;
  mutable burger_tree : int;
  mutable food_truck : int;
  mutable burger_lab : int;
  mutable burger_wormhole : int;
}

type prices = {
  mutable sauce_price : int;
  mutable secret_sauce_price : int;
  mutable spatula_price : int;
  mutable grilling_dad_price : int;
  mutable burger_tree_price : int;
  mutable food_truck_price : int;
  mutable burger_lab_price : int;
  mutable burger_wormhole_price : int;
}

type random_event_draw = {
  mutable x : float;
  mutable y : float;
  mutable alpha : float;
  timer : int;
  mutable random_flag : bool;
  mutable despawn_timer : int;
}

type animation = {
  mutable flag : bool;
  mutable transparency : int;
  mutable despawn_timer : int;
  mutable text : string;
  mutable width : int;
  mutable pause_flag : bool;
  mutable reverse_flag : bool;
}

type achievement = {
  mutable flag : bool;
  mutable past : bool;
  mutable pause_flag : bool;
  mutable reverse_flag : bool;
  mutable image : Raylib.Texture.t option;
  mutable x_pos : int;
  mutable y_pos : int;
  mutable despawn_timer : int;
  mutable threshold : int;
}

val item_init : powerups
val item_price_init : prices
val random_draw : random_event_draw
val animation : animation
val achievement1 : achievement
val achievement2 : achievement
val achievement3 : achievement
val achievement4 : achievement
val achievement5 : achievement
val achievement6 : achievement
val iachievement1 : achievement
val iachievement2 : achievement
val iachievement3 : achievement
val iachievement4 : achievement
val iachievement5 : achievement
val iachievement6 : achievement
val font_color : Raylib.Color.t
val price_color : Raylib.Color.t
val burger_hitbox : Raylib.Rectangle.t
val sauce_hitbox : Raylib.Rectangle.t
val secret_sauce_hitbox : Raylib.Rectangle.t
val spatula_hitbox : Raylib.Rectangle.t
val grilling_dad_hitbox : Raylib.Rectangle.t
val burger_tree_hitbox : Raylib.Rectangle.t
val food_truck_hitbox : Raylib.Rectangle.t
val burger_lab_hitbox : Raylib.Rectangle.t
val burger_wormhole_hitbox : Raylib.Rectangle.t
val random_event_hitbox : Raylib.Rectangle.t
val suffix_array : string list
val random_stats : random_stats
val achievement_maker : int -> int -> int -> achievement
