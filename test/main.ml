open OUnit2
open Help

let test_achievement_maker (name : string) (answer : int) : test =
  name >:: fun _ ->
  let a = achievement_maker ~-340 415 100 in
  a.x_pos <- answer;
  a.flag <- true;
  assert_equal answer a.x_pos;
  assert_equal true a.flag;
  assert_equal false a.past;
  assert_equal false a.pause_flag;
  assert_equal false a.reverse_flag

let test_random_gift (name : string) (burgers : int) (lower_bound : int)
    (upper_bound : int) : test =
  name >:: fun _ ->
  let i = ref 0 in
  while !i < 100 do
    incr i;
    assert_bool "lower-bound failed" (burger_gift burgers >= lower_bound);
    assert_bool "upper bound failed" (burger_gift burgers <= upper_bound)
  done

let test_achievement_threshold (name : string) (a : achievement)
    (threshold : int) : test =
  name >:: fun _ -> assert_equal threshold a.threshold

let test_achievement_y_pos (name : string) (a : achievement) (pos : int) : test
    =
  name >:: fun _ -> assert_equal pos a.y_pos

let test_incr_bur_click (name : string) (info : information) (answer : int) :
    test =
  name >:: fun _ ->
  increment_burger_click info;
  assert_equal answer (int_of_float info.burgers) ~printer:string_of_int

let test_decr_bur_spend (name : string) (info : information) (price : int)
    (answer : int) : test =
  name >:: fun _ ->
  decrease_burger_spend info price;
  assert_equal answer (int_of_float info.burgers) ~printer:string_of_int

let test_incr_bps (name : string) (info : information) (item : string)
    (answer : int) (bps_mult : int ref) : test =
  name >:: fun _ ->
  increment_bps info item bps_mult;
  assert_equal answer info.bps ~printer:string_of_int

let test_incr_bur_bps (name : string) (info : information)
    (frames_per_update : int) (num_secs : int) (answer : int) : test =
  name >:: fun _ ->
  let end_of_while = 60 / frames_per_update in
  let i = ref 0 in
  while !i < num_secs do
    let j = ref 0 in
    while !j < end_of_while do
      increment_burger_bps info frames_per_update;
      incr j
    done;
    incr i
  done;
  assert_equal answer (int_of_float info.burgers) ~printer:string_of_int

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

let init_state () = { burgers = 0.; bps = 0; click_power = 1 }

let one_sauce_nothing_else =
  {
    sauce = 1;
    secret_sauce = 0;
    spatula = 0;
    grilling_dad = 0;
    burger_tree = 0;
    food_truck = 0;
    burger_lab = 0;
    burger_wormhole = 0;
  }

let one_secret_sauce_nothing_else =
  {
    sauce = 0;
    secret_sauce = 1;
    spatula = 0;
    grilling_dad = 0;
    burger_tree = 0;
    food_truck = 0;
    burger_lab = 0;
    burger_wormhole = 0;
  }

let new_item_init () =
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

let suffix_array = [ ""; "K"; "M"; "B"; "T"; "Q" ]
let bps_mult = ref 1

let help_tests =
  [
    test_random_gift "random gift but 0 burgers" 0 0 0;
    test_random_gift "random gift but just 1 burger" 1 0 0;
    test_random_gift "random gift early game burgers (100)" 100 10 30;
    test_random_gift "random gift late game burgers (3423530)" 3423530 342353
      (3423530 * 3);
    test_incr_bur_click "increment with one burger" (init_state ()) 1;
    test_decr_bur_spend "Buying an item"
      { burgers = 10000.; bps = 100; click_power = 2 }
      5000 5000;
    test_incr_bps "buy spatula" (init_state ()) "spatula" 1 bps_mult;
    test_incr_bps "buy grilling dad" (init_state ()) "grilling dad" 5 bps_mult;
    test_incr_bps "buy burger tree" (init_state ()) "burger tree" 50 bps_mult;
    test_incr_bps "buy food truck" (init_state ()) "food truck" 250 bps_mult;
    test_incr_bps "buy burger lab" (init_state ()) "burger lab" 1500 bps_mult;
    test_incr_bps "buy burger wormhole" (init_state ()) "burger wormhole" 10000
      bps_mult;
    test_incr_bur_bps
      "incrementing 1 sec based on 30 bps with 60 frames per update"
      { burgers = 0.; bps = 30; click_power = 2 }
      60 1 30;
    test_incr_bur_bps
      "incrementing 5 sec based on 5 bps with 60 frames per update"
      { burgers = 0.; bps = 30; click_power = 2 }
      60 5 150;
    test_incr_bur_bps
      "incrementing 1 sec based on bps with 60 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      60 1 10100;
    test_incr_bur_bps "incrementing based on bps with 30 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      30 1 10100;
    test_incr_bur_bps "incrementing based on bps with 10 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      10 1 10100;
    test_incr_bur_bps "incrementing based on bps with 5 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      5 1 10100;
    test_incr_bur_bps
      "incrementing 2 sec based on bps with 30 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      30 2 10200;
    test_incr_bur_bps
      "incrementing 15 sec based on bps with 5 frames per update"
      { burgers = 10000.; bps = 100; click_power = 2 }
      5 15 11500;
    test_incr_bur_bps
      "incrementing based on bps with 1 frame per update for a minute"
      { burgers = 10000.; bps = 100; click_power = 2 }
      1 60 16000;
    test_incr_click_pwr "incrementing click power"
      { burgers = 10000.; bps = 100; click_power = 2 }
      2 4;
    test_incr_item "sauce increment from 0 to 1" (new_item_init ()) "sauce"
      item_price_init one_sauce_nothing_else item_price_init;
    test_incr_item "sauce increment from 1 doesn't change"
      one_sauce_nothing_else "sauce" item_price_init one_sauce_nothing_else
      item_price_init;
    test_incr_item "secret sauce increment from 0 to 1" (new_item_init ())
      "secret sauce" item_price_init one_secret_sauce_nothing_else
      item_price_init;
    test_incr_item "secret sauce increment from 1 doesn't change"
      one_secret_sauce_nothing_else "secret sauce" item_price_init
      one_secret_sauce_nothing_else item_price_init;
    (let items = new_item_init () in
     let prices = item_price_init in
     test_incr_item "incrementing grilling dads" items "grilling dad" prices
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
       });
    test_incr_item "incrementing spatulas"
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
      "spatula"
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 15;
        grilling_dad_price = 133;
        burger_tree_price = 1500;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      }
      {
        sauce = 0;
        secret_sauce = 0;
        spatula = 1;
        grilling_dad = 1;
        burger_tree = 0;
        food_truck = 0;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 19;
        grilling_dad_price = 133;
        burger_tree_price = 1500;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      };
    test_incr_item "incrementing burger tree with expected game progression"
      {
        sauce = 0;
        secret_sauce = 0;
        spatula = 4;
        grilling_dad = 3;
        burger_tree = 0;
        food_truck = 0;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      "burger tree"
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 43;
        grilling_dad_price = 234;
        burger_tree_price = 1500;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      }
      {
        sauce = 0;
        secret_sauce = 0;
        spatula = 4;
        grilling_dad = 3;
        burger_tree = 1;
        food_truck = 0;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 43;
        grilling_dad_price = 234;
        burger_tree_price = 1995;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      };
    test_incr_item "incrementing food truck with expected game progression"
      {
        sauce = 1;
        secret_sauce = 0;
        spatula = 10;
        grilling_dad = 5;
        burger_tree = 2;
        food_truck = 0;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      "food truck"
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 231;
        grilling_dad_price = 413;
        burger_tree_price = 2650;
        food_truck_price = 10000;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      }
      {
        sauce = 1;
        secret_sauce = 0;
        spatula = 10;
        grilling_dad = 5;
        burger_tree = 2;
        food_truck = 1;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 231;
        grilling_dad_price = 413;
        burger_tree_price = 2650;
        food_truck_price = 13300;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      };
    test_incr_item "incrementing burger lab with expected game progression"
      {
        sauce = 1;
        secret_sauce = 0;
        spatula = 18;
        grilling_dad = 10;
        burger_tree = 5;
        food_truck = 2;
        burger_lab = 0;
        burger_wormhole = 0;
      }
      "burger lab"
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 2250;
        grilling_dad_price = 1720;
        burger_tree_price = 6240;
        food_truck_price = 17690;
        burger_lab_price = 100000;
        burger_wormhole_price = 1000000;
      }
      {
        sauce = 1;
        secret_sauce = 0;
        spatula = 18;
        grilling_dad = 10;
        burger_tree = 5;
        food_truck = 2;
        burger_lab = 1;
        burger_wormhole = 0;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 2250;
        grilling_dad_price = 1720;
        burger_tree_price = 6240;
        food_truck_price = 17690;
        burger_lab_price = 133000;
        burger_wormhole_price = 1000000;
      };
    test_incr_item "incrementing burger wormhole with expected game progression"
      {
        sauce = 1;
        secret_sauce = 1;
        spatula = 20;
        grilling_dad = 15;
        burger_tree = 10;
        food_truck = 10;
        burger_lab = 10;
        burger_wormhole = 0;
      }
      "burger wormhole"
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 3980;
        grilling_dad_price = 7130;
        burger_tree_price = 25970;
        food_truck_price = 173180;
        burger_lab_price = 1730000;
        burger_wormhole_price = 1000000;
      }
      {
        sauce = 1;
        secret_sauce = 1;
        spatula = 20;
        grilling_dad = 15;
        burger_tree = 10;
        food_truck = 10;
        burger_lab = 10;
        burger_wormhole = 1;
      }
      {
        sauce_price = 1000;
        secret_sauce_price = 500000;
        spatula_price = 3980;
        grilling_dad_price = 7130;
        burger_tree_price = 25970;
        food_truck_price = 173180;
        burger_lab_price = 1730000;
        burger_wormhole_price = 1330000;
      };
    test_truncate "no truncation needed 0" 0. suffix_array "0";
    test_truncate "no truncation needed number greater than 0" 10. suffix_array
      "10";
    test_truncate "truncation needed 1k" 1000. suffix_array "1.00K";
    test_truncate "truncation needed 1k and 500" 1500. suffix_array "1.50K";
    test_truncate "truncation needed 10k" 10000. suffix_array "10.00K";
    test_truncate "truncation needed thousands second decimal point nonzero"
      10010. suffix_array "10.01K";
    test_truncate "truncation needed hundred thousands no digit 0" 592243.
      suffix_array "592.24K";
    test_truncate "truncation needed hundred thousands no digit 0 + rounding"
      592248. suffix_array "592.25K";
    test_truncate "truncation needed 1m" 1000000. suffix_array "1.00M";
    test_truncate "truncation needed 5.89m no rounding" 5890000. suffix_array
      "5.89M";
    test_truncate "truncation needed 5.89m with rounding" 5888000. suffix_array
      "5.89M";
    test_truncate "truncation needed 1b" 1000000000. suffix_array "1.00B";
    test_truncate "truncation needed 4.94b no rounding" 4940000000. suffix_array
      "4.94B";
    test_truncate "truncation needed 4.94b with rounding" 4937000000.
      suffix_array "4.94B";
    test_truncate "truncation needed 1t" 1000000000000. suffix_array "1.00T";
    test_truncate "truncation needed 9.94t no rounding" 9940000000000.
      suffix_array "9.94T";
    test_truncate "truncation needed 9.94t with rounding" 9937000000000.
      suffix_array "9.94T";
    test_truncate "truncation needed 1q" 1000000000000. suffix_array "1.00T";
    test_truncate "truncation needed 5.56q no rounding" 5560000000000000.
      suffix_array "5.56Q";
    test_truncate "truncation needed 5.56q with rounding" 5557000000000000.
      suffix_array "5.56Q";
    test_animate_text "animation initialization" animation "I'm Animating";
    test_achievement_maker "Giving negative x_pos" ~-100;
    test_achievement_maker "Giving positive x_pos" 200;
    test_achievement_threshold "Achievement 1" achievement1 100;
    test_achievement_threshold "Achievement 2" achievement2 1000;
    test_achievement_threshold "Achievement 3" achievement3 10000;
    test_achievement_threshold "Achievement 4" achievement4 100000;
    test_achievement_threshold "Achievement 5" achievement5 1000000;
    test_achievement_threshold "Achievement 6" achievement6 10000000;
    test_achievement_threshold "Item Achievements" iachievement1 1;
    test_achievement_y_pos "Milestone Achievement" achievement3 415;
    test_achievement_y_pos "Item Achievement" iachievement4 155;
  ]

let suite = "help test suite" >::: List.flatten [ help_tests ]
let _ = run_test_tt_main suite
