open Graphics

let main () =
  let a = open_graph " 1200X800" in
  a;
  set_window_title "Burger Clicker";
  set_color black;
  fill_rect 0 0 (size_x a) (size_y a);
  let background = Png.load_as_rgb24 "Burger_Background.png" [] in
  let display_background = Graphic_image.of_image background in
  let img = Png.load_as_rgb24 "Colored_Whopper.png" [] in
  let display_image = Graphic_image.of_image img in
  draw_image display_background 0 0;
  draw_image display_image ((size_x a / 2) - 190) ((size_y a / 2) - 64)

let rec interactive () =
  let event = wait_next_event [ Key_pressed ] in
  if event.key == 'q' then (
    print_string "Thanks For Playing Burger Clicker!";
    exit 0)
  else print_char event.key;
  print_newline ();
  interactive ()

let () =
  main ();
  interactive ()
