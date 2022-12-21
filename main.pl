:- use_module(library(clpfd)).

:- consult('data_gen.pl').
:- consult('grid_op.pl').

cell_eval(Sum, Val, NextVal) :-
    Val in 0..1,
	Sum in 0..8,
	NextVal #<==> Sum #= 3 #\/ (Val #= 1 #/\ Sum #= 2).

gol(Grid, NextGrid, W, H) :-
    grid(Grid, W, H),
	grid(NextGrid, W, H),
    
   	shift_right(Grid, Grid0),
    shift_up(Grid, Grid1),
    shift_left(Grid, Grid2),
    shift_down(Grid, Grid3),
    shift_right(Grid1, Grid4),
    shift_up(Grid2, Grid5),
    shift_left(Grid3, Grid6),
    shift_down(Grid0, Grid7),
    
    grid_sum([Grid0, Grid1, Grid2, Grid3, Grid4, Grid5, Grid6, Grid7], GridSum),
    maplist(maplist(cell_eval), GridSum, Grid, NextGrid).

gol_iter(0, Grid, Grid, _, _).
gol_iter(N, Grid, NextGrid, W, H) :-
	N #> 0,
	NextN #= N - 1,

	gol(Grid, Grid0, W, H),
	gol_iter(NextN, Grid0, NextGrid, W, H).
