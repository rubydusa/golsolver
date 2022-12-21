gridrow(N, Xs) :- 
    length(Xs, N),
    Xs ins 0..1.

grid(Grid, W, H) :-
    length(Grid, H),
    maplist(gridrow(W), Grid).

shift_up(Grid, NextGrid) :-
    append([Head], Tail, Grid),
    append(Tail, [Head], NextGrid).

shift_down(Grid, NextGrid) :-
    append(Init, [Last], Grid),
    append([Last], Init, NextGrid).

shift_right([], []).
shift_right([Row | Rest], [NextRow | NextRest]) :-
    shift_down(Row, NextRow),
    shift_right(Rest, NextRest).

shift_left([], []).
shift_left([Row | Rest], [NextRow | NextRest]) :-
    shift_up(Row, NextRow),
    shift_left(Rest, NextRest).

row_add([], [], []).
row_add([X | Xs], [Y | Ys], [Z | Zs]) :-
    Z #= X + Y,
    row_add(Xs, Ys, Zs).

grid_add([], [], []).
grid_add([Row1 | Rest1], [ Row2 | Rest2 ], [RowSum | RestSum]) :-
    row_add(Row1, Row2, RowSum),
    grid_add(Rest1, Rest2, RestSum).

grid_sum([Grid], Grid).
grid_sum([Grid | Rest], Sum) :-
    grid_sum(Rest, RestSum),
    grid_add(Grid, RestSum, Sum).

