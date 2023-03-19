module G = Graphics
module H = Help

let stats = H.init

let background a =
  G.set_window_title "Burger Clicker";
  let background = Png.load_as_rgb24 "BurgerBackground.png" [] in
  let display_background = Graphic_image.of_image background in
  let img = Png.load_as_rgb24 "ColoredWhopperFixed.png" [] in
  let display_image = Graphic_image.of_image img in
  G.draw_image display_background 0 0;
  G.draw_image display_image ((G.size_x a / 2) - 182) 352;
  G.set_color (G.rgb 51 44 80)

let main () =
  let a = G.open_graph " 1200X800" in
  background a

let rec interactive a () =
  let event = G.wait_next_event [ G.Key_pressed; G.Button_down ] in
  if event.button then (
    if
      event.mouse_x > 400 && event.mouse_x < 540 && event.mouse_y > 350
      && event.mouse_y < 450
    then H.increment_burger stats;
    background a;
    G.moveto 420 685;
    Graphics.set_font "-*-fixed-medium-r-semicondensed--75-*-*-*-*-*-iso8859-1";
    G.draw_string (string_of_int stats.burgers);

    if event.key == 'q' then (
      print_string "Thanks For Playing Burger Clicker!";
      exit 0)
    else interactive a ())

let () =
  main ();
  print_newline ();
  interactive (main ()) ()
