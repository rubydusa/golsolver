:- module(ndarray, [
	ndarray/2,
	ndarray_add/2,
	ndarray_sub/2,
	ndarray_mul/2,
	shift_ndarray/3
]).
:- use_module(library(clpfd)).

ndarray([], [0 | _]) --> [].
ndarray([H | T], [Dim]) --> 
    {
    Dim #> 0,
    Dim #= Dim0 + 1
    },
    [H],
    ndarray(T, [Dim0]).
ndarray([H | T], [Dim0, Dim1 | Dims]) --> 
    {
    Dim0 #> 0,
    Dim0 #= NextDim0 + 1
    },
    ndarray(H, [Dim1 | Dims]), 
    ndarray(T, [NextDim0, Dim1 | Dims]).

vector_add([], [], []).
vector_add([H0 | T0], [H1 | T1], [H | T]) :-
    H #= H0 + H1,
    vector_add(T0, T1, T).

vector_sub([], [], []).
vector_sub([H0 | T0], [H1 | T1], [H | T]) :-
    H #= H0 - H1,
    vector_sub(T0, T1, T).

vector_mul([], [], []).
vector_mul([H0 | T0], [H1 | T1], [H | T]) :-
    H #= H0 * H1,
    vector_mul(T0, T1, T).

ndarray(Array, Dims) :-
    phrase(ndarray(Array, Dims), _).

ndarray_add([Array], Array).
ndarray_add([Array0, Array1 | Rest], Array) :-
    phrase(ndarray(Array0, Dims), Vector0),
    phrase(ndarray(Array1, Dims), Vector1),
    catch(
        vector_add(Vector0, Vector1, Vector),
        error(domain_error(clpfd_expression, _), _),
        false
    ),
	phrase(ndarray(Array2, Dims), Vector),
    ndarray_add([Array2 | Rest], Array).

ndarray_sub([Array], Array).
ndarray_sub([Array0, Array1 | Rest], Array) :-
    phrase(ndarray(Array0, Dims), Vector0),
    phrase(ndarray(Array1, Dims), Vector1),
    catch(
        vector_sub(Vector0, Vector1, Vector),
        error(domain_error(clpfd_expression, _), _),
        false
    ),
	phrase(ndarray(Array2, Dims), Vector),
    ndarray_sub([Array2 | Rest], Array).

ndarray_mul([Array], Array).
ndarray_mul([Array0, Array1 | Rest], Array) :-
    phrase(ndarray(Array0, Dims), Vector0),
    phrase(ndarray(Array1, Dims), Vector1),
    catch(
        vector_mul(Vector0, Vector1, Vector),
        error(domain_error(clpfd_expression, _), _),
        false
    ),
	phrase(ndarray(Array2, Dims), Vector),
    ndarray_mul([Array2 | Rest], Array).

seq([]) --> [].
seq([H | T]) --> [H], seq(T).

init_last(Init, Last) --> seq(Init), [Last].
shift_r(List) --> { phrase(init_last(Init, Last), List) }, [Last], seq(Init).
shift_r(List, 0) --> seq(List).
shift_r(List, N) --> 
    { 
    N #> 0, 
    N #= N0 + 1,
    phrase(shift_r(List), List0)
    }, 
    shift_r(List0, N0).

shift_l([H | T]) --> seq(T), [H].
shift_l(List, 0) --> seq(List).
shift_l(List, N) --> 
    {
    N #> 0,
    N #= N0 + 1,
    phrase(shift_l(List), List0)
    },
    shift_l(List0, N0).

shift_ndarray([], Array, Array).
shift_ndarray([0 | DimShifts], Array, Shifted) :-
    maplist(shift_ndarray(DimShifts), Array, Shifted).
shift_ndarray([+DimShift | DimShifts], Array, Shifted) :-
    maplist(shift_ndarray(DimShifts), Array, Shifted0),
    phrase(shift_r(Shifted0, DimShift), Shifted).
shift_ndarray([-DimShift | DimShifts], Array, Shifted) :-
    maplist(shift_ndarray(DimShifts), Array, Shifted0),
    phrase(shift_l(Shifted0, DimShift), Shifted).

