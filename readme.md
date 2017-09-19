# Zagafaction

![screenshot of maze generator and solver](http://i.imgur.com/S0qKukJ.png)

Zagafaction is a procedural map generation utility intended to be used for generating mazes with pleasing and interesting qualities. It uses [Prim's Algorithm](http://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm) at its core, but where Prim's algorithm uses randomness to make decisions I've injected a set of design principles that I think will make for better mazes.

I'm currently working on a series of articles that will explain the underlying principles.

Zagafaction uses rasem to generate svg output for visualizing the mazes.

To see it in action do

```bash
ruby lib/zagafaction.rb
```

If the generation takes too long, use ctrl+c to exit out. It really shouldn't take very long.
