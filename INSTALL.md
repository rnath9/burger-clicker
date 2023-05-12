Once you have installed the source code for this project, 
you must also make the following installs in the terminal
for everything to run correctly. This is written assuming 
that the 3110 OCaml environment is already set up. If not,
visit this link for installation instructions:
https://cs3110.github.io/textbook/chapters/preface/install.html

For Windows Users:

Open up Ubuntu, paste the following line and hit enter:

opam install raylib

For Mac Users:

Paste this line in terminal:

opam install dune graphics camlimages conf-libpng

Then, in the top-level, run the following line:
  #require "graphics";;
If graphics does not still work, try the following line:
  #load "graphics.cma";;

After running these lines in the terminal, you should be able to 
"dune build" the project and type the command "make play" to run
the game.
