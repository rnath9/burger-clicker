module R = Raylib
(**[information] holds the user's stats — namely their burgers, bps, and clicking power.*)

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
(**[powerups] contains the number of powerups a user has.*)

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

(**[prices] holds the prices associated with each powerup enumerated in [powerups]*)

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
  timer : int;
  mutable random_flag : bool;
  mutable despawn_timer : int;
}

(**[item_init] initializes the number of powerups each user has at the start of
      the game*)
let item_init =
  {
    sauce = 0;
    secret_sauce = 0;
    spatula = 0;
    grilling_dad = 0;
    burger_tree = 0;
    food_truck = 0;
    burger_lab = 0;
    burger_wormhole = 0;
  }
(**[item_price_init] initializes the prices for each of the power ups a user may
    get at the start of the game.*)

let item_price_init =
  {
    sauce_price = 1000;
    secret_sauce_price = 500000;
    spatula_price = 15;
    grilling_dad_price = 100;
    burger_tree_price = 1500;
    food_truck_price = 10000;
    burger_lab_price = 100000;
    burger_wormhole_price = 1000000;
  }

let random_draw =
  { x = 0.; y = 0.; timer = 0; random_flag = false; despawn_timer = 0 }

type animation = {
  mutable flag : bool;
  mutable transparency : int;
  mutable despawn_timer : int;
  mutable text : string;
  mutable width : int;
  mutable pause_flag : bool;
  mutable reverse_flag : bool;
}

let animation =
  {
    flag = false;
    transparency = 255;
    despawn_timer = 0;
    text = "";
    width = 0;
    pause_flag = false;
    reverse_flag = false;
  }

type achievement = {
  mutable flag : bool;
  mutable past : bool;
  mutable pause_flag : bool;
  mutable reverse_flag : bool;
  mutable image : R.Texture.t option;
  mutable x_pos : int;
  mutable y_pos : int;
  mutable despawn_timer : int;
  mutable threshold : int;
}

let achievement_maker x y t =
  {
    flag = false;
    past = false;
    pause_flag = false;
    reverse_flag = false;
    image = None;
    x_pos = x;
    y_pos = y;
    despawn_timer = 500;
    threshold = t;
  }

let achievement1 = achievement_maker ~-340 415 100
let achievement2 = achievement_maker ~-340 415 1000
let achievement3 = achievement_maker ~-340 415 10000
let achievement4 = achievement_maker ~-340 415 100000
let achievement5 = achievement_maker ~-340 415 1000000
let achievement6 = achievement_maker ~-340 415 10000000
let iachievement1 = achievement_maker ~-340 155 1
let iachievement2 = achievement_maker ~-340 155 1
let iachievement3 = achievement_maker ~-340 155 1
let iachievement4 = achievement_maker ~-340 155 1
let iachievement5 = achievement_maker ~-340 155 1
let iachievement6 = achievement_maker ~-340 155 1
let font_color = R.Color.create 50 42 79 255
let price_color = R.Color.create 226 243 228 255
let burger_hitbox = R.Rectangle.create 375. 293. 110. 85.
let sauce_hitbox = R.Rectangle.create 880. 222. 85. 38.
let secret_sauce_hitbox = R.Rectangle.create 1005. 222. 85. 38.
let spatula_hitbox = R.Rectangle.create 1020. 299. 85. 38.
let grilling_dad_hitbox = R.Rectangle.create 1020. 369. 85. 38.
let burger_tree_hitbox = R.Rectangle.create 1020. 439. 85. 38.
let food_truck_hitbox = R.Rectangle.create 1020. 509. 85. 38.
let burger_lab_hitbox = R.Rectangle.create 1020. 579. 85. 38.
let burger_wormhole_hitbox = R.Rectangle.create 1020. 649. 254. 109.
let random_event_hitbox = R.Rectangle.create 0. 0. 0. 0.
let suffix_array = [ ""; "K"; "M"; "B"; "T"; "Q" ]
let random_stats = { chance = 1500; timer = 0; min_time = 10 }
