include Config
include Randomevent

(**[information] holds the user's stats — namely their burgers, bps, and clicking power.*)

(** [burger_init] initializes the game with 0 burgers, 0 burgers per second, 
    and 1 burger per click.*)
let burger_init = { burgers = 1500; bps = 0; click_power = 1 }

(** [increment_burger_click] increments the burger count by one click 
    in a given information type [t].*)
let increment_burger_click t = t.burgers <- t.burgers + t.click_power

(**[decrease_burger_spend t price] decreases the burger count by [price] in a 
    given information type [t].*)
let decrease_burger_spend t price = t.burgers <- t.burgers - price

(**[increment_bps t item] increments the burgers per second depending on [item] in a 
    given information type [t].*)
let increment_bps t item =
  t.bps <-
    (t.bps
    +
    match item with
    | "spatula" -> 1
    | "grilling dad" -> 5
    | "burger tree" -> 50
    | "food truck" -> 250
    | "burger lab" -> 1500
    | "burger wormhole" -> 10000
    | _ -> failwith "attempted to increase bps with invalid item")

(**[increment_burger_bps t] increments the total burgers by the burger per second
in a given information type [t]*)
let increment_burger_bps t = t.burgers <- t.burgers + t.bps

(**[increment_click_power t mult] increments the amount of burgers the user gets in one
    click by a multiplier [mult] in a given information type [t]*)
let increment_click_power t mult = t.click_power <- t.click_power * mult

(**[powerups] contains the number of powerups a user has.*)

(**[prices] holds the prices associated with each powerup enumerated in [powerups]*)

(**[item_init] initializes the number of powerups each user has at the start of
      the game*)

(**[item_price_init] initializes the prices for each of the power ups a user may
    get at the start of the game.*)

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
  | "sauce" -> p.sauce <- false
  | "secret sauce" -> p.secret_sauce <- false
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
    state price_list =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if !state = 6 && burger_stats.burgers > price then (
        state := 4;
        decrease_burger_spend burger_stats price;
        increment_item item_stats item price_list;
        increment_bps burger_stats item)

let perm_upgrade (price : int) (item : string) mouse hitbox purchased pr
    burger_stats item_stats state price_list =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if !state = 6 && burger_stats.burgers > pr && purchased then (
        state := 4;
        decrease_burger_spend burger_stats price;
        increment_item item_stats item price_list;
        increment_click_power burger_stats 10)

let random_events random_stats burger_stats bps_mult click_mult =
  if random_stats.timer = 0 then
    match Randomevent.generate_event random_stats.chance with
    | "burger gift" ->
        print_endline "BURGER GIFT";
        burger_stats.burgers <-
          burger_stats.burgers + Randomevent.burger_gift burger_stats.burgers
    | "bps boost" ->
        print_endline "BPS BOOST";
        bps_mult := Rand.int 3 + 2;
        burger_stats.bps <- !bps_mult * burger_stats.bps;
        Randomevent.generate_timer random_stats
    | "click power boost" ->
        print_endline "CLICK BOOST";
        click_mult := Rand.int 10 + 10;
        burger_stats.click_power <- !click_mult * burger_stats.click_power;
        Randomevent.generate_timer random_stats
    | "advice" -> ()
    | "nothing" -> ()
    | _ -> failwith "random event error"
  else if random_stats.timer = -1 then (
    burger_stats.bps <- burger_stats.bps / !bps_mult;
    bps_mult := 1;
    random_stats.timer <- random_stats.timer + 1)
  else random_stats.timer <- random_stats.timer + 1
