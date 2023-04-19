module R = Raylib
module H = Help

let burger_stats = H.burger_init
let item_stats = H.item_init
let price_list = H.item_price_init
let random_stats = H.init_random_stats
let bps_mult = ref 1
let click_mult = ref 1
let random_draw = H.random_event_draw_init
let state = ref 0

(*state: 0 mouse up
  state: 1 mouse hover over burger
  state: 2 mouse pressed over burger
  state: 3 mouse released over burger
  state: 4 mouse hover over buy button
  state: 5 mouse pressed buy button
  state: 6 mouse released buy button *)
let time = ref 0

let setup () =
  R.init_window 1120 700 "Burger Clicker";
  R.set_target_fps 60;
  let bg_image = R.load_image "images/RescaledBurgerBackground.png" in
  let bg_texture = R.load_texture_from_image bg_image in
  R.unload_image bg_image;
  let burger_image = R.load_image "images/Transparent_Burger.png" in
  let burger_texture = R.load_texture_from_image burger_image in
  R.unload_image burger_image;
  let buy_image = R.load_image "images/Buy.png" in
  let buy_texture = R.load_texture_from_image buy_image in
  R.unload_image buy_image;
  let buy_hover_image = R.load_image "images/Buy_hover.png" in
  let buy_hover_texture = R.load_texture_from_image buy_hover_image in
  R.unload_image buy_hover_image;
  let buy_clicked_image = R.load_image "images/Buy_clicked.png" in
  let buy_clicked_texture = R.load_texture_from_image buy_clicked_image in
  R.unload_image buy_clicked_image;
  let burger_hover_image = R.load_image "images/WhopperHighlight.png" in
  let burger_hover_texture = R.load_texture_from_image burger_hover_image in
  R.unload_image burger_hover_image;
  let burger_clicked_image = R.load_image "images/WhopperClicked.png" in
  let burger_clicked_texture = R.load_texture_from_image burger_clicked_image in
  R.unload_image burger_clicked_image;
  let golden_burger_image = R.load_image "images/GoldenWhopper.png" in
  let golden_burger_texture = R.load_texture_from_image golden_burger_image in
  R.unload_image golden_burger_image;

  ( bg_texture,
    burger_texture,
    burger_hover_texture,
    burger_clicked_texture,
    buy_texture,
    buy_hover_texture,
    buy_clicked_texture,
    golden_burger_texture )

let hover_mechanics mouse buy_clicked buy_hover hitbox coord =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then (
      if !state = 5 then (
        state := 6;
        R.draw_texture buy_clicked (fst coord) (snd coord) R.Color.raywhite))
    else (
      state := 5;
      R.draw_texture buy_hover (fst coord) (snd coord) R.Color.raywhite)

(* let text_draw text x y color size = R.draw_text text x y size color *)

let text_draw text x y color size =
  R.draw_text_ex (R.get_font_default ()) text
    (R.Vector2.create (float_of_int x) (float_of_int y))
    (float_of_int size) 5. color

let rec loop texture =
  let ( bg,
        burger,
        burger_hover,
        burger_clicked,
        buy,
        buy_hover,
        buy_clicked,
        golden_burger ) =
    texture
  in
  match R.window_should_close () with
  | true -> R.close_window ()
  | _ ->
      R.begin_drawing ();
      R.clear_background R.Color.raywhite;
      R.draw_texture bg 0 0 R.Color.raywhite;
      R.draw_texture burger 375 293 R.Color.raywhite;
      R.draw_texture buy 1005 222 R.Color.raywhite;
      R.draw_texture buy 880 222 R.Color.raywhite;
      R.draw_texture buy 1020 299 R.Color.raywhite;
      R.draw_texture buy 1020 369 R.Color.raywhite;
      R.draw_texture buy 1020 439 R.Color.raywhite;
      R.draw_texture buy 1020 509 R.Color.raywhite;
      R.draw_texture buy 1020 579 R.Color.raywhite;
      R.draw_texture buy 1020 649 R.Color.raywhite;
      time := !time + 1;
      if !time = 60 then (
        time := 0;
        H.increment_burger_bps burger_stats);
      if R.is_mouse_button_down R.MouseButton.Left = false then state := 0;
      let mouse_point = R.get_mouse_position () in
      if R.check_collision_point_rec mouse_point H.burger_hitbox then
        if R.is_mouse_button_down R.MouseButton.Left then (
          if !state = 2 then (
            state := 3;
            R.draw_texture burger_clicked 375 293 R.Color.raywhite;
            H.increment_burger_click burger_stats))
        else (
          state := 2;
          R.draw_texture burger_hover 375 293 R.Color.raywhite);
      hover_mechanics mouse_point buy_clicked buy_hover H.sauce_hitbox (880, 222);
      hover_mechanics mouse_point buy_clicked buy_hover H.secret_sauce_hitbox
        (1005, 222);
      hover_mechanics mouse_point buy_clicked buy_hover H.spatula_hitbox
        (1020, 299);
      hover_mechanics mouse_point buy_clicked buy_hover H.grilling_dad_hitbox
        (1020, 369);
      hover_mechanics mouse_point buy_clicked buy_hover H.burger_tree_hitbox
        (1020, 439);
      hover_mechanics mouse_point buy_clicked buy_hover H.food_truck_hitbox
        (1020, 509);
      hover_mechanics mouse_point buy_clicked buy_hover H.burger_lab_hitbox
        (1020, 579);
      hover_mechanics mouse_point buy_clicked buy_hover H.burger_wormhole_hitbox
        (1020, 649);

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
                R.draw_texture burger_clicked
                  (int_of_float random_draw.x)
                  (int_of_float random_draw.y)
                  R.Color.raywhite;
                H.random_events random_stats burger_stats bps_mult click_mult;
                random_draw.random_flag <- false))
            else (
              state := 2;
              R.draw_texture burger_hover
                (int_of_float random_draw.x)
                (int_of_float random_draw.y)
                R.Color.raywhite))
        else if H.Rand.int 100 = 1 then (
          H.Rand.self_init ();
          random_draw.x <- H.Rand.int 730 + 20 |> float_of_int;
          random_draw.y <- H.Rand.int 350 + 115 |> float_of_int;
          random_draw.random_flag <- true;
          random_draw.despawn_timer <- 600))
      else if random_stats.timer = -1 then (
        burger_stats.bps <- burger_stats.bps / !bps_mult;
        burger_stats.click_power <- burger_stats.click_power / !click_mult;
        bps_mult := 1;
        click_mult := 1;
        random_stats.timer <- random_stats.timer + 1)
      else random_stats.timer <- random_stats.timer + 1;

      H.perm_upgrade price_list.sauce_price "sauce" mouse_point H.sauce_hitbox
        item_stats.sauce price_list.sauce_price burger_stats item_stats state
        price_list;

      H.perm_upgrade price_list.secret_sauce_price "secret sauce" mouse_point
        H.secret_sauce_hitbox item_stats.secret_sauce
        price_list.secret_sauce_price burger_stats item_stats state price_list;

      H.shop price_list.spatula_price "spatula" mouse_point H.spatula_hitbox
        burger_stats item_stats state price_list bps_mult;

      H.shop price_list.grilling_dad_price "grilling dad" mouse_point
        H.grilling_dad_hitbox burger_stats item_stats state price_list bps_mult;

      H.shop price_list.burger_tree_price "burger tree" mouse_point
        H.burger_tree_hitbox burger_stats item_stats state price_list bps_mult;

      H.shop price_list.food_truck_price "food truck" mouse_point
        H.food_truck_hitbox burger_stats item_stats state price_list bps_mult;

      H.shop price_list.burger_lab_price "burger lab" mouse_point
        H.burger_lab_hitbox burger_stats item_stats state price_list bps_mult;

      H.shop price_list.burger_wormhole_price "burger wormhole" mouse_point
        H.burger_wormhole_hitbox burger_stats item_stats state price_list
        bps_mult;

      text_draw
        (H.truncate (float_of_int burger_stats.burgers) H.suffix_array)
        505 15 H.font_color 100;

      text_draw
        (H.truncate (float_of_int burger_stats.bps) H.suffix_array)
        400 105 H.font_color 40;

      text_draw
        (H.truncate (float_of_int price_list.spatula_price) H.suffix_array)
        910 302 H.price_color 35;
      text_draw
        (H.truncate (float_of_int price_list.grilling_dad_price) H.suffix_array)
        910 372 H.price_color 35;
      text_draw
        (H.truncate (float_of_int price_list.burger_tree_price) H.suffix_array)
        910 442 H.price_color 35;
      text_draw
        (H.truncate (float_of_int price_list.food_truck_price) H.suffix_array)
        910 512 H.price_color 35;
      text_draw
        (H.truncate (float_of_int price_list.burger_lab_price) H.suffix_array)
        910 582 H.price_color 35;
      text_draw
        (H.truncate
           (float_of_int price_list.burger_wormhole_price)
           H.suffix_array)
        910 652 H.price_color 35;

      text_draw (string_of_int item_stats.spatula) 165 555 H.font_color 50;
      text_draw (string_of_int item_stats.grilling_dad) 165 640 H.font_color 50;
      text_draw (string_of_int item_stats.burger_tree) 365 555 H.font_color 50;
      text_draw (string_of_int item_stats.food_truck) 365 640 H.font_color 50;
      text_draw (string_of_int item_stats.burger_lab) 600 555 H.font_color 50;
      text_draw
        (string_of_int item_stats.burger_wormhole)
        600 640 H.font_color 50;

      R.end_drawing ();
      loop texture

let () = setup () |> loop
