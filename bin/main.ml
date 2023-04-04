module R = Raylib
module H = Help

let stats = H.init

(*move state to stats later*)
let state = ref 0

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
      if R.is_mouse_button_down R.MouseButton.Left = false then state := 0;
      let mouse_point = R.get_mouse_position () in
      if R.check_collision_point_rec mouse_point burger_hitbox then
        (*we can even switch the burger to look like you've hovered over it!*)
        if R.is_mouse_button_down R.MouseButton.Left then
          if !state = 0 then (
            state := 1;
            H.increment_burger stats);
      R.draw_text
        (string_of_int stats.burgers)
        425 30 100
        (R.Color.create 50 42 79 255);
      R.end_drawing ();
      loop texture

let () = setup () |> loop
