include Config
include Randomevent

(** [burger_init] initializes the game with 0 burgers, 0 burgers per second, 
    and 1 burger per click.*)
let burger_init = { burgers = 1000.; bps = 0; click_power = 1 }

(** [increment_burger_click] increments the burger count by one click 
    in a given information type [t].*)
let increment_burger_click t =
  t.burgers <- t.burgers +. float_of_int t.click_power

(**[decrease_burger_spend t price] decreases the burger count by [price] in a 
    given information type [t].*)
let decrease_burger_spend t price = t.burgers <- t.burgers -. float_of_int price

(**[increment_bps t item] increments the burgers per second depending on [item] in a 
    given information type [t].*)
let increment_bps t item bps_mult =
  t.bps <-
    (t.bps
    +
    match item with
    | "spatula" -> 1 * !bps_mult
    | "grilling dad" -> 5 * !bps_mult
    | "burger tree" -> 50 * !bps_mult
    | "food truck" -> 250 * !bps_mult
    | "burger lab" -> 1500 * !bps_mult
    | "burger wormhole" -> 10000 * !bps_mult
    | _ -> failwith "attempted to increase bps with invalid item")

(**[increment_burger_bps t] increments the total burgers by the burger per second divided by [frames_per_update]
in a given information type [t]*)
let increment_burger_bps t frames_per_update =
  let new_val =
    t.burgers +. (float_of_int t.bps /. float_of_int (60 / frames_per_update))
  in
  let new_val_rounding = new_val -. (new_val |> int_of_float |> float_of_int) in
  if new_val_rounding > 0.9999 then
    t.burgers <- new_val +. 0.1 |> int_of_float |> float_of_int
  else t.burgers <- new_val

(**[increment_click_power t mult] increments the amount of burgers the user gets in one
    click by a multiplier [mult] in a given information type [t]*)
let increment_click_power t mult = t.click_power <- t.click_power * mult

(**[increase_price price] is used to increase the price [price] of an item by 33% of its intial 
    cost after buying it. Example: if [price] is 300, [increase_price price] will return
    a new suitable price of 399. Decimals are rounded through the standard library function 
    [int_of_float]*)
let increase_price (price : int) =
  (price |> float_of_int) *. 1.33 |> int_of_float

(**[increment_item p item] updates the amount of an item [item] in [p] and records its new 
    associated price in a mutable record [pr]. Example: if a spatula is bought, 
    then [increment_item p "spatula" pr] would increment [p.spatula] by 1, and update [pr.spatula_price]
    using [increase_price]*)
let increment_item p item (pr : prices) =
  match item with
  | "sauce" -> p.sauce <- 1
  | "secret sauce" -> p.secret_sauce <- 1
  | "spatula" ->
      p.spatula <-
        (pr.spatula_price <- pr.spatula_price |> increase_price;
         p.spatula + 1)
  | "grilling dad" ->
      p.grilling_dad <-
        (pr.grilling_dad_price <- pr.grilling_dad_price |> increase_price;
         p.grilling_dad + 1)
  | "burger tree" ->
      p.burger_tree <-
        (pr.burger_tree_price <- pr.burger_tree_price |> increase_price;
         p.burger_tree + 1)
  | "food truck" ->
      p.food_truck <-
        (pr.food_truck_price <- pr.food_truck_price |> increase_price;
         p.food_truck + 1)
  | "burger lab" ->
      p.burger_lab <-
        (pr.burger_lab_price <- pr.burger_lab_price |> increase_price;
         p.burger_lab + 1)
  | "burger wormhole" ->
      p.burger_wormhole <-
        (pr.burger_wormhole_price <- pr.burger_wormhole_price |> increase_price;
         p.burger_wormhole + 1)
  | _ -> failwith "Unknown item attempt"

(**[round3 n] rounds [n] to the nearest hundredth*)
let round3 n = Float.(n *. 100.0 |> round |> fun x -> x /. 100.0)

(**[truncate num suffix] handles the logic for representing a digit on the top of
    the screen for user view.*)
let rec truncate num suffix =
  match round3 num with
  | n when n < 1000. -> (
      let suff = List.hd suffix in
      match suff with
      | "" -> n |> int_of_float |> string_of_int
      | _ ->
          string_of_float n
          ^ (match
               String.length (string_of_float n)
               - (int_of_float n |> string_of_int |> String.length)
             with
            | 1 -> "00"
            | 2 -> "0"
            | _ -> "")
          ^ suff)
  | n -> truncate (n /. 1000.) (List.tl suffix)

let shop (price : int) (item : string) mouse hitbox burger_stats item_stats
    state price_list bps_mult =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if !state = 6 && int_of_float burger_stats.burgers >= price then (
        state := 4;
        decrease_burger_spend burger_stats price;
        increment_item item_stats item price_list;
        increment_bps burger_stats item bps_mult)

let perm_upgrade (price : int) (item : string) mouse hitbox purchased pr
    burger_stats item_stats state price_list =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if !state = 6 && int_of_float burger_stats.burgers > pr && purchased = 0
      then (
        state := 4;
        decrease_burger_spend burger_stats price;
        increment_item item_stats item price_list;
        increment_click_power burger_stats 10)

let animate_text (animation : animation) (text : string) =
  animation.text <- text;
  animation.width <- R.measure_text animation.text 40;
  animation.flag <- true

let random_events (random_stats : random_stats) burger_stats bps_mult click_mult
    =
  if random_stats.timer = 0 then
    match Rand.int 4 with
    | 0 ->
        let burger_gift =
          Randomevent.burger_gift (int_of_float burger_stats.burgers)
        in
        animate_text animation ("BURGER GIFT! + " ^ string_of_int burger_gift);
        burger_stats.burgers <- burger_stats.burgers +. float_of_int burger_gift
    | 1 ->
        bps_mult := Rand.int 3 + 2;
        animate_text animation
          ("BPS BOOST! " ^ string_of_int !bps_mult ^ "X MORE EFFICIENCY");
        burger_stats.bps <- !bps_mult * burger_stats.bps;
        Randomevent.generate_timer random_stats
    | 2 ->
        click_mult := Rand.int 10 + 10;
        animate_text animation
          ("CLICK BOOST! " ^ string_of_int !click_mult ^ "X MORE EFFICIENCY");
        burger_stats.click_power <- !click_mult * burger_stats.click_power;
        Randomevent.generate_timer random_stats
    | 3 ->
        animate_text animation
          (match Rand.int 5 with
          | 0 -> "Try Clicking the Right Burger"
          | 1 -> "Why Are You Still Playing?"
          | 2 -> "You're Playing the Music Right?"
          | 3 -> "Think About All the Dead Cows"
          | _ -> "*Wet Meat Noises*")
    | _ -> failwith "random event error"

let facilitate_events golden_burger golden_burger_clicked golden_burger_hover
    mouse_point state burger_stats bps_mult click_mult =
  if random_stats.timer = 0 then (
    random_draw.despawn_timer <- random_draw.despawn_timer - 1;
    if random_draw.despawn_timer = 0 then random_draw.random_flag <- false;
    if random_draw.random_flag then (
      R.draw_texture golden_burger
        (int_of_float random_draw.x)
        (int_of_float random_draw.y)
        R.Color.raywhite;
      if
        R.check_collision_point_rec mouse_point
          (R.Rectangle.create random_draw.x random_draw.y 70. 55.)
      then
        if R.is_mouse_button_down R.MouseButton.Left then (
          if !state = 2 then (
            state := 3;
            R.draw_texture golden_burger_clicked
              (int_of_float random_draw.x)
              (int_of_float random_draw.y)
              R.Color.raywhite;
            random_events random_stats burger_stats bps_mult click_mult;
            random_draw.random_flag <- false))
        else (
          state := 2;
          R.draw_texture golden_burger_hover
            (int_of_float random_draw.x)
            (int_of_float random_draw.y)
            R.Color.raywhite))
    else if Rand.int random_stats.chance = 1 then (
      Rand.self_init ();
      random_draw.x <- Rand.int 730 + 20 |> float_of_int;
      random_draw.y <- Rand.int 375 + 115 |> float_of_int;
      random_draw.random_flag <- true;
      random_draw.despawn_timer <- 600))
  else if random_stats.timer = -1 then (
    burger_stats.bps <- burger_stats.bps / !bps_mult;
    burger_stats.click_power <- burger_stats.click_power / !click_mult;
    bps_mult := 1;
    click_mult := 1;
    random_stats.timer <- random_stats.timer + 1)
  else random_stats.timer <- random_stats.timer + 1

let text_draw text x y color size =
  R.draw_text_ex (R.get_font_default ()) text
    (R.Vector2.create (float_of_int x) (float_of_int y))
    (float_of_int (size - 10))
    5. color

let animate_random () =
  if animation.flag then
    if animation.transparency = 0 then (
      animation.pause_flag <- true;
      animation.flag <- false;
      animation.despawn_timer <- 60)
    else (
      animation.transparency <- animation.transparency - 5;
      text_draw animation.text
        (425 - (animation.width / 2))
        250
        (R.Color.create 50 42 79 (255 - animation.transparency))
        40);

  if animation.pause_flag then
    if animation.despawn_timer = 0 then (
      animation.reverse_flag <- true;
      animation.pause_flag <- false)
    else (
      text_draw animation.text
        (425 - (animation.width / 2))
        250
        (R.Color.create 50 42 79 (255 - animation.transparency))
        40;
      animation.despawn_timer <- animation.despawn_timer - 1);

  if animation.reverse_flag then
    if animation.transparency = 255 then animation.reverse_flag <- false
    else (
      animation.transparency <- animation.transparency + 5;
      text_draw animation.text
        (425 - (animation.width / 2))
        250
        (R.Color.create 50 42 79 (255 - animation.transparency))
        40)
