:- use_module(library(random)).

% Data generation utils

random_grid(Grid, W, H) :-
	grid(Grid, W, H),
	maplist(maplist(random_between(0, 1)), Grid).

random_test_data(W, H, X) :-
	random_grid(Grid, W, H),
	gol(Grid, NextGrid, W, H),
	flatten(Grid, FGrid),
	flatten(NextGrid, FNextGrid),
	X = [FGrid, FNextGrid].

nrandom_test_data(N, W, H, X) :-
	random_grid(Grid, W, H),
	gol_iter(N, Grid, NextGrid, W, H),
	flatten(Grid, FGrid),
	flatten(NextGrid, FNextGrid),
	X = [FGrid, FNextGrid].

from_bin(Grid, Val) :-
	flatten(Grid, FGrid),
	from_bin0(0, Val, FGrid).

from_bin0(_, 0, []).
from_bin0(N, Accm, [B | Rest]) :-
	NextN is N + 1,
	from_bin0(NextN, RestAccm, Rest),
	Accm is (B * (2 ^ N)) + RestAccm. 

to_bin(0, [0]).
to_bin(1, [1]).
to_bin(N, [B | Rest]) :-
	N #> 1,
	B #= N /\ 1,
	N0 #= N >> 1,
	to_bin(N0, Rest).

chunkify([], []).
chunkify([A, B, C, D, E, F, G, H | Rest0], [[A, B, C, D, E, F, G, H] | Rest]) :-
	chunkify(Rest0, Rest).

zero_pad(L0, N, L) :-
	length(L, N),
	append(L0, L1, L),
	maplist(=(0), L1).
