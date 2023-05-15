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

opam install raylib

After running these lines in the terminal, you should be able to 
"dune build" the project and type the command "make play" to run
the game.

For both Mac and Windows, if the program still isn't runnable, you may need to 
run eval $(opam env) to ensure that you are properly activating the switch.

If it says you are missing certain packages, for Windows, try:
  sudo apt-get update
  sudo apt install pkg-config libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev

or for Mac:
  brew install pkg-config libxcursor libxi libxinerama libxrandr

If you are still missing certain packages that aren't associated with OCaml, follow
the installation directions given to you by the terminal output of "opam install raylib"
(for example, if your terminal output says you need a certain package before reinstalling,
install that package using sudo apt install or brew install as is appropriate).