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
    (answer : int) : test =
  name >:: fun _ ->
  increment_bps info item;
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

let test_truncate (name : string) (num : float) (suffix : string list)
    (answer : string) : test =
  name >:: fun _ -> assert_equal answer (truncate num suffix)

let init_state = { burgers = 0; bps = 0; click_power = 1 }
let suffix_array = [ ""; "K"; "M"; "B"; "T"; "Q" ]

let help_tests =
  [
    test_incr_bur_click "increment with one burger" init_state 1;
    test_decr_bur_spend "Buying an item"
      { burgers = 10000; bps = 100; click_power = 2 }
      5000 5000;
    test_incr_bps "buy spatula" init_state "spatula" 1;
    test_incr_bur_bps "incrementing based on bps"
      { burgers = 10000; bps = 100; click_power = 2 }
      10100;
    test_incr_click_pwr "incrementing click power"
      { burgers = 10000; bps = 100; click_power = 2 }
      2 4;
    test_truncate "no truncation needed" 10. suffix_array "10.";
    test_truncate "truncation needed" 103400000. suffix_array "103.4M";
  ]

let suite = "help test suite" >::: List.flatten [ help_tests ]
let _ = run_test_tt_main suite
