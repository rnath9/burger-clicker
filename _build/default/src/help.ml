include Config

type information = {
  mutable burgers : int;
  mutable bps : int;
  mutable click_power : int;
}

let burger_init = { burgers = 1000000000000000; bps = 0; click_power = 1 }
let increment_burger_click t = t.burgers <- t.burgers + t.click_power
let decrease_burger_spend t price = t.burgers <- t.burgers - price

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

let increment_burger_bps t = t.burgers <- t.burgers + t.bps
let increment_click_power t mult = t.click_power <- t.click_power * mult

type powerups_list = {
  mutable sauce : bool;
  mutable secret_sauce : bool;
  mutable spatula : int;
  mutable grilling_dad : int;
  mutable burger_tree : int;
  mutable food_truck : int;
  mutable burger_lab : int;
  mutable burger_wormhole : int;
}

type price_list = {
  mutable sauce_price : int;
  mutable secret_sauce_price : int;
  mutable spatula_price : int;
  mutable grilling_dad_price : int;
  mutable burger_tree_price : int;
  mutable food_truck_price : int;
  mutable burger_lab_price : int;
  mutable burger_wormhole_price : int;
}

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

let increase_price (price : int) =
  (price |> float_of_int) *. 1.33 |> int_of_float

let increment_item p item (pr : price_list) =
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

let round3 n = Float.(n *. 100.0 |> round |> fun x -> x /. 100.0)

let rec truncate num suffix =
  match round3 num with
  | n when n < 1000. -> string_of_float n ^ List.hd suffix
  | n -> truncate (n /. 1000.) (List.tl suffix)
