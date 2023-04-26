open OUnit2
open Help

let test_incr_bur_click (name : string) (info : information) (answer : int) :
    test =
  name >:: fun _ ->
  increment_burger_click info;
  assert_equal answer info.burgers ~printer:string_of_int

let test_decr_bur_spend (name : string) (info : information) (price : int)
    (answer : int) : test =
  name >:: fun _ ->
  decrease_burger_spend info price;
  assert_equal answer info.burgers ~printer:string_of_int

let test_incr_bps (name : string) (info : information) (item : string)
    (answer : int) (bps_mult : int ref) : test =
  name >:: fun _ ->
  increment_bps info item bps_mult;
  assert_equal answer info.bps ~printer:string_of_int

let test_incr_bur_bps (name : string) (info : information) (answer : int) : test
    =
  name >:: fun _ ->
  increment_burger_bps info;
  assert_equal answer info.burgers ~printer:string_of_int

let test_incr_click_pwr (name : string) (info : information) (mult : int)
    (answer : int) : test =
  name >:: fun _ ->
  increment_click_power info mult;
  assert_equal answer info.click_power ~printer:string_of_int

let test_incr_item (name : string) (powerups : powerups) (item : string)
    (prices : prices) (new_powerups : powerups) (new_prices : prices) : test =
  name >:: fun _ ->
  assert (
    increment_item powerups item prices;
    powerups = new_powerups && prices = new_prices)

let test_truncate (name : string) (num : float) (suffix : string list)
    (answer : string) : test =
  name >:: fun _ -> assert_equal answer (truncate num suffix)

let test_animate_text (name : string) (animation : animation) (text : string) :
    test =
  name >:: fun _ ->
  assert (
    animate_text animation text;
    animation.text = text && animation.flag = true)

let init_state = { burgers = 0; bps = 0; click_power = 1 }
let suffix_array = [ ""; "K"; "M"; "B"; "T"; "Q" ]
let bps_mult = ref 1

let help_tests =
  [
    test_incr_bur_click "increment with one burger" init_state 1;
    test_decr_bur_spend "Buying an item"
      { burgers = 10000; bps = 100; click_power = 2 }
      5000 5000;
    test_incr_bps "buy spatula" init_state "spatula" 1 bps_mult;
    test_incr_bur_bps "incrementing based on bps"
      { burgers = 10000; bps = 100; click_power = 2 }
      10100;
    test_incr_click_pwr "incrementing click power"
      { burgers = 10000; bps = 100; click_power = 2 }
      2 4;
    test_incr_item "incrementing burger dads" item_init "grilling dad"
      item_price_init
      {
        sauce = 0;
        secret_sauce = 0;
        spatula = 0;
        grilling_dad = 1;
        burger_tree = 0;
        food_truck = 0;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 15;
        grilling_dad_price = 133;
        burger_tree_price = 1500;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      };
    test_truncate "no truncation needed" 10. suffix_array "10";
    test_truncate "truncation needed" 103400000. suffix_array "103.40M";
    test_animate_text "animation initialization" animation "I'm Animating";
  ]

let suite = "help test suite" >::: List.flatten [ help_tests ]
let _ = run_test_tt_main suite
