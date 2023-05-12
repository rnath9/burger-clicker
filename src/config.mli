(**Configuration of types and starting values used throughout the game*)

(**[Config] was designed to store most of our types and values that we make use
    of throughout the game. This module is frequently used by other modules to get
    common values that are needed, like hitboxes or game states.*)

type information = {
  mutable burgers : float;
  mutable bps : int;
  mutable click_power : int;
}
(** [information] is the record that holds [burgers], the number of burgers,
    [bps], the player's burgers per second, and [click_power], how many burgers
    the player gets per click. *)

type random_stats = {
  mutable chance : int;
  mutable timer : int;
  mutable min_time : int;
}
(** [random_stats] is the record that holds all of the information regarding
    random events. *)

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
(** [powerups] is the record that holds the quantity of each power-up that the
    player owns.*)

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
(** [prices] is the record that holds all the prices of each power-up that can
    be bought in the shop*)

type random_event_draw = {
  mutable x : float;
  mutable y : float;
  timer : int;
  mutable random_flag : bool;
  mutable despawn_timer : int;
}
(** [random_event_draw] is the record that holds all the information needed to
    draw a random event burger on the screen. *)

type animation = {
  mutable flag : bool;
  mutable transparency : int;
  mutable despawn_timer : int;
  mutable text : string;
  mutable width : int;
  mutable pause_flag : bool;
  mutable reverse_flag : bool;
}
(** [animation] is the record that holds all the information regarding animating
    text on the screen after clicking a random event.*)

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
(** [achievement] is the record that holds all the information regarding 
    animating achievements.*)

val item_init : powerups
(** [item_init] initializes the number of powerups each user has at the start of
      the game.*)

val item_price_init : prices
(**[item_price_init] initializes the prices for each of the power ups a user may
    get at the start of the game.*)

val random_draw : random_event_draw
(** [random_draw] initializes the data of a random event to be drawn.*)

val animation : animation
(** [animation] initializes the data of a sentence to be animated above the 
    burger.*)

val achievement1 : achievement
(** [achievement1] holds the information for animating the first burger quantity
     achievement.*)

val achievement2 : achievement
(** [achievement2] holds the information for animating the second burger 
    quantity achievement.*)

val achievement3 : achievement
(** [achievement3] holds the information for animating the third burger quantity
    achievement.*)

val achievement4 : achievement
(** [achievement4] holds the information for animating the fourth burger 
    quantity achievement.*)

val achievement5 : achievement
(** [achievement5] holds the information for animating the fifth burger quantity
    achievement.*)

val achievement6 : achievement
(** [achievement1] holds the information for animating the sixth burger quantity
    achievement.*)

val iachievement1 : achievement
(** [iachievement1] holds the information for animating the first item shop
    achievement.*)

val iachievement2 : achievement
(** [iachievement2] holds the information for animating the second item shop
    achievement.*)

val iachievement3 : achievement
(** [iachievement3] holds the information for animating the third item shop
    achievement.*)

val iachievement4 : achievement
(** [iachievement4] holds the information for animating the fourth item shop
    achievement.*)

val iachievement5 : achievement
(** [iachievement5] holds the information for animating the fifth item shop
    achievement.*)

val iachievement6 : achievement
(** [iachievement6] holds the information for animating the sixth item shop
    achievement.*)

val font_color : Raylib.Color.t
(** [font_color] holds the [Raylib.Color.t] value for general font color.*)

val price_color : Raylib.Color.t
(** [price_color] holds the [Raylib.Color.t] value for shop price font color.*)

val burger_hitbox : Raylib.Rectangle.t
(** [burger_hitbox] holds the [Raylib.Rectangle.t] that represents the hitbox of
    the burger*)

val sauce_hitbox : Raylib.Rectangle.t
(** [sauce_hitbox] holds the [Raylib.Rectangle.t] that represents the hitbox of
    the sauce upgrade*)

val secret_sauce_hitbox : Raylib.Rectangle.t
(** [secret_sauce_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the secret_sauce upgrade*)

val spatula_hitbox : Raylib.Rectangle.t
(** [spatula_hitbox] holds the [Raylib.Rectangle.t] that represents the hitbox 
    of the spatula shop button*)

val grilling_dad_hitbox : Raylib.Rectangle.t
(** [grilling_dad_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the grilling dad shop button*)

val burger_tree_hitbox : Raylib.Rectangle.t
(** [burger_tree_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the bureger tree shop button*)

val food_truck_hitbox : Raylib.Rectangle.t
(** [food_truck_hitbox] holds the [Raylib.Rectangle.t] that represents the
    hitbox of the food truck shop button*)

val burger_lab_hitbox : Raylib.Rectangle.t
(** [burger_lab_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the burger_lab shop button*)

val burger_wormhole_hitbox : Raylib.Rectangle.t
(** [burger_wormhole_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the burger wormhole shop button*)

val random_event_hitbox : Raylib.Rectangle.t
(** [random_event_hitbox] holds the [Raylib.Rectangle.t] that represents the 
    hitbox of the random event burger that appears on the screen*)

val suffix_array : string list
(** [suffix_array] is a list of strings that each represent abbreviations for
    quantities like "M" for million*)

val random_stats : random_stats
(** [random_stats] holds the information regarding the spawing time and 
    cooldown of random events*)

val achievement_maker : int -> int -> int -> achievement
(** [achievement_maker x y t] takes in the starting [x] and [y] values of the
    achievement and additionally a value [t] which controls how long the image
    of the achievement will display. This function returns a new achievement 
    type with those specified attributes with all others being defaulted.*)
