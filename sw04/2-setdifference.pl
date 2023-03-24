set_difference([], _, []).
set_difference(L, [], L).
set_difference([Head|Tail], L, R) :-
    \+ member(Head, L),
    !,
    append([Head], R1, R),
    set_difference(Tail, L, R1).
set_difference([_|Tail], L, R) :-
    set_difference(Tail, L, R).