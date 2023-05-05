module R = Raylib
module H = Help

let burger_stats = H.burger_init
let item_stats = H.item_init
let price_list = H.item_price_init
let bps_mult = ref 1
let click_mult = ref 1
let state = ref 0
let won_game = ref false

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
  let win_image = R.load_image "images/WinScreen.png" in
  let win_texture = R.load_texture_from_image win_image in
  R.unload_image win_image;
  let boss = R.load_image "images/BurgerBoss.png" in
  let boss_texture = R.load_texture_from_image boss in
  R.unload_image boss;
  let burger_image = R.load_image "images/Transparent_Burger.png" in
  let burger_texture = R.load_texture_from_image burger_image in
  R.unload_image burger_image;
  let leader = R.load_image "images/BurgerLeader.png" in
  let leader_texture = R.load_texture_from_image leader in
  R.unload_image leader;
  let king = R.load_image "images/BurgerKing.png" in
  let king_texture = R.load_texture_from_image king in
  R.unload_image king;
  let expert = R.load_image "images/BurgerExpert.png" in
  let expert_texture = R.load_texture_from_image expert in
  R.unload_image expert;
  let monster = R.load_image "images/BurgerMonster.png" in
  let monster_texture = R.load_texture_from_image monster in
  R.unload_image monster;
  let goat = R.load_image "images/BurgerGoat.png" in
  let goat_texture = R.load_texture_from_image goat in
  R.unload_image goat;
  let spatula = R.load_image "images/FryCook.png" in
  let spatula_texture = R.load_texture_from_image spatula in
  R.unload_image spatula;
  let grill = R.load_image "images/TheChef.png" in
  let grill_texture = R.load_texture_from_image grill in
  R.unload_image grill;
  let tree = R.load_image "images/Newton.png" in
  let tree_texture = R.load_texture_from_image tree in
  R.unload_image tree;
  let truck = R.load_image "images/ElJefe.png" in
  let truck_texture = R.load_texture_from_image truck in
  R.unload_image truck;
  let lab = R.load_image "images/BillNye.png" in
  let lab_texture = R.load_texture_from_image lab in
  R.unload_image lab;
  let hole = R.load_image "images/Nether.png" in
  let hole_texture = R.load_texture_from_image hole in
  R.unload_image hole;
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
  let golden_burger_hover_image =
    R.load_image "images/HoveredGoldenWhopper.png"
  in
  let golden_burger_hover_texture =
    R.load_texture_from_image golden_burger_hover_image
  in
  R.unload_image golden_burger_hover_image;
  let golden_burger_clicked_image =
    R.load_image "images/ClickedGoldenWhopper.png"
  in
  let golden_burger_clicked_texture =
    R.load_texture_from_image golden_burger_clicked_image
  in
  R.unload_image golden_burger_clicked_image;

  ( bg_texture,
    win_texture,
    boss_texture,
    leader_texture,
    king_texture,
    expert_texture,
    monster_texture,
    goat_texture,
    spatula_texture,
    grill_texture,
    tree_texture,
    truck_texture,
    lab_texture,
    hole_texture,
    burger_texture,
    burger_hover_texture,
    burger_clicked_texture,
    buy_texture,
    buy_hover_texture,
    buy_clicked_texture,
    golden_burger_texture,
    golden_burger_hover_texture,
    golden_burger_clicked_texture )

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

let rec loop frames_per_update texture =
  let ( bg,
        win,
        boss,
        leader,
        king,
        expert,
        monster,
        goat,
        spatula,
        grill,
        tree,
        truck,
        lab,
        hole,
        burger,
        burger_hover,
        burger_clicked,
        buy,
        buy_hover,
        buy_clicked,
        golden_burger,
        golden_burger_hover,
        golden_burger_clicked ) =
    texture
  in
  match R.window_should_close () with
  | true -> R.close_window ()
  | _ -> (
      match !won_game with
      | false ->
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
          if !time = 60 then time := 0;
          if !time mod frames_per_update = 0 then
            H.increment_burger_bps burger_stats frames_per_update;
          if R.is_mouse_button_down R.MouseButton.Left = false then state := 0;

          H.facilitate_achievements boss leader king expert monster goat spatula
            grill tree truck lab hole burger_stats item_stats;
          let mouse_point = R.get_mouse_position () in
          H.facilitate_events golden_burger golden_burger_clicked
            golden_burger_hover mouse_point state burger_stats bps_mult
            click_mult;
          if R.check_collision_point_rec mouse_point H.burger_hitbox then
            if R.is_mouse_button_down R.MouseButton.Left then (
              if !state = 2 then (
                state := 3;
                R.draw_texture burger_clicked 375 293 R.Color.raywhite;
                H.increment_burger_click burger_stats))
            else (
              state := 2;
              R.draw_texture burger_hover 375 293 R.Color.raywhite);
          hover_mechanics mouse_point buy_clicked buy_hover H.sauce_hitbox
            (880, 222);
          hover_mechanics mouse_point buy_clicked buy_hover
            H.secret_sauce_hitbox (1005, 222);
          hover_mechanics mouse_point buy_clicked buy_hover H.spatula_hitbox
            (1020, 299);
          hover_mechanics mouse_point buy_clicked buy_hover
            H.grilling_dad_hitbox (1020, 369);
          hover_mechanics mouse_point buy_clicked buy_hover H.burger_tree_hitbox
            (1020, 439);
          hover_mechanics mouse_point buy_clicked buy_hover H.food_truck_hitbox
            (1020, 509);
          hover_mechanics mouse_point buy_clicked buy_hover H.burger_lab_hitbox
            (1020, 579);
          hover_mechanics mouse_point buy_clicked buy_hover
            H.burger_wormhole_hitbox (1020, 649);

          H.perm_upgrade price_list.sauce_price "sauce" mouse_point
            H.sauce_hitbox item_stats.sauce price_list.sauce_price burger_stats
            item_stats state price_list;

          H.perm_upgrade price_list.secret_sauce_price "secret sauce"
            mouse_point H.secret_sauce_hitbox item_stats.secret_sauce
            price_list.secret_sauce_price burger_stats item_stats state
            price_list;

          H.shop price_list.spatula_price "spatula" mouse_point H.spatula_hitbox
            burger_stats item_stats state price_list bps_mult;

          H.shop price_list.grilling_dad_price "grilling dad" mouse_point
            H.grilling_dad_hitbox burger_stats item_stats state price_list
            bps_mult;

          H.shop price_list.burger_tree_price "burger tree" mouse_point
            H.burger_tree_hitbox burger_stats item_stats state price_list
            bps_mult;

          H.shop price_list.food_truck_price "food truck" mouse_point
            H.food_truck_hitbox burger_stats item_stats state price_list
            bps_mult;

          H.shop price_list.burger_lab_price "burger lab" mouse_point
            H.burger_lab_hitbox burger_stats item_stats state price_list
            bps_mult;

          H.shop price_list.burger_wormhole_price "burger wormhole" mouse_point
            H.burger_wormhole_hitbox burger_stats item_stats state price_list
            bps_mult;

          H.text_draw
            (H.truncate burger_stats.burgers H.suffix_array)
            505 20 H.font_color 100;

          H.text_draw
            (H.truncate (float_of_int burger_stats.bps) H.suffix_array)
            400 110 H.font_color 40;

          H.text_draw
            (H.truncate (float_of_int price_list.spatula_price) H.suffix_array)
            910 305 H.price_color 35;
          H.text_draw
            (H.truncate
               (float_of_int price_list.grilling_dad_price)
               H.suffix_array)
            910 375 H.price_color 35;
          H.text_draw
            (H.truncate
               (float_of_int price_list.burger_tree_price)
               H.suffix_array)
            910 445 H.price_color 35;
          H.text_draw
            (H.truncate
               (float_of_int price_list.food_truck_price)
               H.suffix_array)
            910 515 H.price_color 35;
          H.text_draw
            (H.truncate
               (float_of_int price_list.burger_lab_price)
               H.suffix_array)
            910 585 H.price_color 35;
          H.text_draw
            (H.truncate
               (float_of_int price_list.burger_wormhole_price)
               H.suffix_array)
            910 655 H.price_color 35;

          H.text_draw (string_of_int item_stats.spatula) 165 558 H.font_color 50;
          H.text_draw
            (string_of_int item_stats.grilling_dad)
            165 643 H.font_color 50;
          H.text_draw
            (string_of_int item_stats.burger_tree)
            365 558 H.font_color 50;
          H.text_draw
            (string_of_int item_stats.food_truck)
            365 643 H.font_color 50;
          H.text_draw
            (string_of_int item_stats.burger_lab)
            600 558 H.font_color 50;
          H.text_draw
            (string_of_int item_stats.burger_wormhole)
            600 643 H.font_color 50;

          H.animate_random ();
          (* R.draw_fps 250 250; *)
          if burger_stats.burgers > (1.0 *. (10. ** 300.)) +. 1. then
            won_game := true;
          R.end_drawing ();
          loop frames_per_update texture
      | true ->
          R.begin_drawing ();
          R.clear_background R.Color.white;
          R.draw_fps 200 200;
          R.draw_texture win 0 0 R.Color.white;
          R.end_drawing ();
          loop frames_per_update texture)

let () = setup () |> loop 5
