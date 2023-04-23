include Config

type information = {
  mutable burgers : int;
  mutable bps : int;
  mutable click_power : int;
}
(**[information] holds the user's stats — namely their burgers, bps, and clicking power.*)

(** [burger_init] initializes the game with 0 burgers, 0 burgers per second, 
    and 1 burger per click.*)
let burger_init = { burgers = 0; bps = 0; click_power = 1 }

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

type powerups = {
  mutable sauce : bool;
  mutable secret_sauce : bool;
  mutable spatula : int;
  mutable grilling_dad : int;
  mutable burger_tree : int;
  mutable food_truck : int;
  mutable burger_lab : int;
  mutable burger_wormhole : int;
}
(**[powerups] contains the number of powerups a user has.*)

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
(**[prices] holds the prices associated with each powerup enumerated in [powerups]*)

(**[item_init] initializes the number of powerups each user has at the start of
      the game*)
let item_init =
  {
    sauce = true;
    secret_sauce = true;
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
    secret_sauce_price = 50000;
    spatula_price = 15;
    grilling_dad_price = 100;
    burger_tree_price = 1500;
    food_truck_price = 10000;
    burger_lab_price = 100000;
    burger_wormhole_price = 1000000;
  }

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
      | _ -> string_of_float n ^ "0" ^ suff)
  | n -> truncate (n /. 1000.) (List.tl suffix)
