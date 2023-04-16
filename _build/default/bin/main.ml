module R = Raylib
module H = Help

let burger_stats = H.burger_init
let item_stats = H.item_init
let price_list = H.item_price_init

(*move state to stats later*)
let state = ref 0
let time = ref 0

let setup () =
  R.init_window 1120 700 "Burger Clicker";
  R.set_target_fps 60;
  let bg_image = R.load_image "RescaledBurgerBackground.png" in
  let bg_texture = R.load_texture_from_image bg_image in
  R.unload_image bg_image;
  let burger_image = R.load_image "Transparent_Burger.png" in
  let burger_texture = R.load_texture_from_image burger_image in
  R.unload_image burger_image;
  let buy_image = R.load_image "Buy.png" in
  let buy_texture = R.load_texture_from_image buy_image in
  R.unload_image buy_image;
  (bg_texture, burger_texture, buy_texture)

let font_color = R.Color.create 50 42 79 255
let price_color = R.Color.create 226 243 228 255
let burger_hitbox = R.Rectangle.create 375. 293. 110. 85.
let sauce_hitbox = R.Rectangle.create 870. 115. 84. 30.
let secret_sauce_hitbox = R.Rectangle.create 1005. 222. 84. 30.
let spatula_hitbox = R.Rectangle.create 1020. 299. 84. 30.
let grilling_dad_hitbox = R.Rectangle.create 1020. 369. 84. 30.
let burger_tree_hitbox = R.Rectangle.create 1020. 439. 84. 30.
let food_truck_hitbox = R.Rectangle.create 1020. 509. 84. 30.
let burger_lab_hitbox = R.Rectangle.create 1020. 579. 84. 30.
let burger_wormhole_hitbox = R.Rectangle.create 1020. 649. 254. 109.

let shop (price : int) (item : string) mouse hitbox =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if !state = 0 && burger_stats.burgers > price then (
        state := 1;
        H.decrease_burger_spend burger_stats price;
        H.increment_item item_stats item price_list;
        H.increment_bps burger_stats item)

let perm_upgrade (price : int) (item : string) mouse hitbox purchased =
  if R.check_collision_point_rec mouse hitbox then
    if R.is_mouse_button_down R.MouseButton.Left then
      if
        !state = 0 && burger_stats.burgers > price_list.sauce_price && purchased
      then (
        state := 1;
        H.decrease_burger_spend burger_stats price;
        H.increment_item item_stats item price_list;
        H.increment_click_power burger_stats 10)

let text_draw num x y color size =
  R.draw_text (string_of_int num) x y size color

let rec loop texture =
  let bg, burger, buy = texture in
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

      perm_upgrade price_list.sauce_price "sauce" mouse_point sauce_hitbox
        item_stats.sauce;

      perm_upgrade price_list.secret_sauce_price "secret sauce" mouse_point
        secret_sauce_hitbox item_stats.secret_sauce;

      shop price_list.spatula_price "spatula" mouse_point spatula_hitbox;

      shop price_list.grilling_dad_price "grilling dad" mouse_point
        grilling_dad_hitbox;

      shop price_list.burger_tree_price "burger tree" mouse_point
        burger_tree_hitbox;

      shop price_list.food_truck_price "food truck" mouse_point
        food_truck_hitbox;

      shop price_list.burger_lab_price "burger lab" mouse_point
        burger_lab_hitbox;

      shop price_list.burger_wormhole_price "burger wormhole" mouse_point
        burger_wormhole_hitbox;

      text_draw burger_stats.burgers 505 15 font_color 100;

      text_draw burger_stats.bps 400 105 font_color 40;

      text_draw price_list.spatula_price 910 302 price_color 35;
      text_draw price_list.grilling_dad_price 910 372 price_color 35;
      text_draw price_list.burger_tree_price 910 442 price_color 35;
      text_draw price_list.food_truck_price 910 512 price_color 35;
      text_draw price_list.burger_lab_price 910 582 price_color 35;
      text_draw price_list.burger_wormhole_price 910 652 price_color 35;

      text_draw item_stats.spatula 165 555 font_color 50;
      text_draw item_stats.grilling_dad 165 640 font_color 50;
      text_draw item_stats.burger_tree 365 555 font_color 50;
      text_draw item_stats.food_truck 365 640 font_color 50;
      text_draw item_stats.burger_lab 600 555 font_color 50;
      text_draw item_stats.burger_wormhole 600 640 font_color 50;

      R.end_drawing ();
      loop texture

let () = setup () |> loop
