Once you have installed the source code for this project, 
you must also make the following installs in the terminal
for everything to run correctly.

For Windows Users:
Open up Ubuntu and paste the following lines into it individually,
hitting enter in between each line:

opam install graphics

opam install camlimages

opam conf-libpng

sudo apt-get install -y xfonts-base

For Mac Users:




After running these lines in the terminal, you should be able to 
"dune build" the project and type the command "make play" to run
the game.
