:- use_module(library(clpfd)).
:- use_module("ndarray").

cell_eval(Sum, Val, NextVal) :-
    Val in 0..1,
	Sum in 0..8,
	NextVal #<==> Sum #= 3 #\/ (Val #= 1 #/\ Sum #= 2).

gol(Grid, NextGrid, W, H) :-
	ndarray(Grid, [W, H]),
	ndarray(NextGrid, [W, H]),
    
	shift_ndarray([0, +(1)], Grid, Grid0),
	shift_ndarray([+(1), +(1)], Grid, Grid1),
	shift_ndarray([+(1), 0], Grid, Grid2),
	shift_ndarray([+(1), -(1)], Grid, Grid3),
	shift_ndarray([0, -(1)], Grid, Grid4),
	shift_ndarray([-(1), -(1)], Grid, Grid5),
	shift_ndarray([-(1), 0], Grid, Grid6),
	shift_ndarray([-(1), +(1)], Grid, Grid7),
    
    ndarray_add([Grid0, Grid1, Grid2, Grid3, Grid4, Grid5, Grid6, Grid7], GridSum),
    maplist(maplist(cell_eval), GridSum, Grid, NextGrid).

gol_iter(0, Grid, Grid, _, _).
gol_iter(N, Grid, NextGrid, W, H) :-
	N #> 0,
	NextN #= N - 1,

	gol(Grid, Grid0, W, H),
	gol_iter(NextN, Grid0, NextGrid, W, H).
