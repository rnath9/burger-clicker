module R = Raylib
module H = Help

let burger_stats = H.burger_init
let item_stats = H.item_init
let price_list = H.item_price_init

(*move state to stats later*)
let state = ref 0
let time = ref 0

let setup () =
  R.init_window 1200 800 "Burger Clicker";
  R.set_target_fps 60;
  let bg_image = R.load_image "BurgerBackground.png" in
  let bg_texture = R.load_texture_from_image bg_image in
  R.unload_image bg_image;
  let burger_image = R.load_image "Transparent_Burger.png" in
  let burger_texture = R.load_texture_from_image burger_image in
  R.unload_image burger_image;
  (bg_texture, burger_texture)

let burger_hitbox = R.Rectangle.create 425. 350. 100. 100.
let sauce_hitbox = R.Rectangle.create 940. 130. 114. 149.
let secret_sauce_hitbox = R.Rectangle.create 1060. 130. 134. 149.
let spatula_hitbox = R.Rectangle.create 940. 284. 254. 75.
let grilling_dad_hitbox = R.Rectangle.create 940. 365. 254. 74.
let burger_tree_hitbox = R.Rectangle.create 940. 445. 254. 74.
let food_truck_hitbox = R.Rectangle.create 940. 525. 254. 74.
let burger_lab_hitbox = R.Rectangle.create 940. 605. 254. 74.
let burger_wormhole_hitbox = R.Rectangle.create 940. 685. 254. 109.

let rec loop texture =
  let bg = fst texture in
  let burger = snd texture in
  match R.window_should_close () with
  | true -> R.close_window ()
  | _ ->
      R.begin_drawing ();
      R.clear_background R.Color.raywhite;
      R.draw_texture bg 0 0 R.Color.raywhite;
      R.draw_texture burger 425 350 R.Color.raywhite;
      time := !time + 1;
      if !time = 60 then (
        time := 0;
        H.increment_burger_bps burger_stats)
      else ();
      if R.is_mouse_button_down R.MouseButton.Left = false then state := 0;
      let mouse_point = R.get_mouse_position () in
      if R.check_collision_point_rec mouse_point burger_hitbox then
        (*we can even switch the burger to look like you've hovered over it!*)
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 then (
            state := 1;
            H.increment_burger_click burger_stats);

      (*The following hitbox detections should probably be moved into another
        function called shop or something like that*)
      if R.check_collision_point_rec mouse_point sauce_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if
            !state = 0
            && burger_stats.burgers > price_list.sauce_price
            && item_stats.sauce
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.sauce_price;
            H.increment_item item_stats "sauce" price_list;
            H.increment_click_power burger_stats 2);

      if R.check_collision_point_rec mouse_point secret_sauce_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if
            !state = 0
            && burger_stats.burgers > price_list.secret_sauce_price
            && item_stats.secret_sauce
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.secret_sauce_price;
            H.increment_item item_stats "secret sauce" price_list;
            H.increment_click_power burger_stats 10);

      if R.check_collision_point_rec mouse_point spatula_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 && burger_stats.burgers > price_list.spatula_price then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.spatula_price;
            H.increment_item item_stats "spatula" price_list;
            H.increment_bps burger_stats "spatula");

      if R.check_collision_point_rec mouse_point grilling_dad_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 && burger_stats.burgers > price_list.grilling_dad_price
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.grilling_dad_price;
            H.increment_item item_stats "grilling dad" price_list;
            H.increment_bps burger_stats "grilling dad");

      if R.check_collision_point_rec mouse_point burger_tree_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 && burger_stats.burgers > price_list.burger_tree_price
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.burger_tree_price;
            H.increment_item item_stats "burger tree" price_list;
            H.increment_bps burger_stats "burger tree");

      if R.check_collision_point_rec mouse_point food_truck_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 && burger_stats.burgers > price_list.food_truck_price
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.food_truck_price;
            H.increment_item item_stats "food truck" price_list;
            H.increment_bps burger_stats "food truck");

      if R.check_collision_point_rec mouse_point burger_lab_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 && burger_stats.burgers > price_list.burger_lab_price
          then (
            state := 1;
            H.decrease_burger_spend burger_stats price_list.burger_lab_price;
            H.increment_item item_stats "burger lab" price_list;
            H.increment_bps burger_stats "burger lab");

      if R.check_collision_point_rec mouse_point burger_wormhole_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then
          if
            !state = 0
            && burger_stats.burgers > price_list.burger_wormhole_price
          then (
            state := 1;
            H.decrease_burger_spend burger_stats
              price_list.burger_wormhole_price;
            H.increment_item item_stats "burger wormhole" price_list;
            H.increment_bps burger_stats "burger wormhole");

      R.draw_text
        (string_of_int burger_stats.burgers)
        425 30 100
        (R.Color.create 50 42 79 255);
      R.draw_text
        (string_of_int burger_stats.bps)
        415 120 40
        (R.Color.create 50 42 79 255);
      R.end_drawing ();
      loop texture

let () = setup () |> loop
