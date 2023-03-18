module G = Graphics

let main () =
  let a = G.open_graph " 1200X800" in
  a;
  G.set_window_title "Burger Clicker";
  G.set_color G.black;
  G.fill_rect 0 0 (G.size_x a) (G.size_y a);
  let background = Png.load_as_rgb24 "Burger_Background.png" [] in
  let display_background = Graphic_image.of_image background in
  let img = Png.load_as_rgb24 "Colored_Whopper.png" [] in
  let display_image = Graphic_image.of_image img in
  G.draw_image display_background 0 0;
  G.draw_image display_image ((G.size_x a / 2) - 190) ((G.size_y a / 2) - 64)

let rec interactive () =
  let event = G.wait_next_event [ G.Key_pressed; G.Button_down ] in
  if event.button then (
    if
      event.mouse_x > 400 && event.mouse_x < 540 && event.mouse_y > 350
      && event.mouse_y < 450
    then print_endline "hit";
    if event.key == 'q' then (
      print_string "Thanks For Playing Burger Clicker!";
      exit 0)
    else print_char event.key;
    interactive ())

let () =
  main ();
  print_newline ();
  interactive ()
