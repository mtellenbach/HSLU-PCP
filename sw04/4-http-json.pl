:- use_module(library(http/http_client)).  % http_get(), http_post()
:- use_module(library(http/http_json)).    % json()
:- use_module(library(http/json)).         % atom_json_dict()
:- use_module(library(http/json_convert)). % prolog_to_json()
:- use_module(library(clpfd)).

% Relationship-Problem
female(mary). female(liz). female(mia). female(tina). female(ann). female(sue).% all females
male(mike). male(jack). male(fred). male(tom). male(joe). male(jim). % all males
parent(mary, mia). parent(mary, fred). parent(mary, tina). % all childern of mary
parent(mike, mia). parent(mike, fred). parent(mike, tina). % all children of mike
parent(liz, tom). parent(liz, joe). % allchildern of liz
parent(jack, tom). parent(jack, joe). % all childern of jack
parent(mia, ann). % all childern of mia
parent(tina, sue). parent(tina, jim). % all childern of tina
parent(tom, sue). parent(tom, jim). % all childern of tom

% a) mother/2 and father/2
mother(M, C) :- parent(M, C), female(M).
father(F, C) :- parent(F, C), male(F).

%b sibling/2
sibling(A, B) :- parent(X, A), parent(X, B).

%c grandmother/2
grandmother(A, B) :- mother(A, X), parent(X, B).

%d offspring/2
offspring(O, P) :- parent(P, O).
offspring(O, P) :- offspring(O, X), offspring(X, P).


% Sudoku-Problem 
sudoku(Rows) :-
    append(Rows, Vs), Vs ins 1..9,
    maplist(all_distinct, Rows),
    transpose(Rows, Columns),
    maplist(all_distinct, Columns),
    Rows = [A, B, C, D, E, F, G, H, I],
    blocks(A, B, C), blocks(D, E, F), blocks(G, H, I),
    maplist(label, Rows).

blocks([], [], []).
blocks([A, B, C | T1], [D, E, F | T2], [G, H, I | T3]) :-
    all_distinct([A, B, C, D, E, F, G, H, I]),
    blocks(T1, T2, T3).

    :- json_object
    relationship_solution(problemKey:integer, solution:atom),
    sudoku_solution(problemKey:integer, solution:list).



replace_all([], []).
replace_all([H|A], [H|B]) :-
    H \= 0,
    !,
    replace_all(A, B).
replace_all([0|A], [_|B]) :-
    replace_all(A, B).

replace_all_lists([], []).
replace_all_lists([H|A], [R|B]) :-
    replace_all(H, R),
    replace_all_lists(A, B).

solve(Type, Id) :-
    format(atom(URL), 'http://localhost:16316/problem/~s/~d', [Type, Id]),
    http_get(URL, json(Json), []),
    solve(Type, Id, Json).

solve(relationship, Id, Json) :-
    member(relationship=Relationship, Json),
    member(firstPerson=FirstPerson, Json),
    member(secondPerson=SecondPerson, Json),
    call_result(Relationship, FirstPerson, SecondPerson, X),
    format("\n~s\n", [X]),
    prolog_to_json(relationship_solution(Id, X), Payload),
    http_post('http://localhost:16316/problem/relationship', json(Payload), Response, []),
    write(Response).

solve(sudoku, Id, Json) :-
    member(sudoku=Sudoku, Json),
    replace_all_lists(Sudoku, Puzzle),
    Puzzle = [A, B, C, D, E, F, G, H, I],
    sudoku([A, B, C, D, E, F, G, H, I]),
    prolog_to_json(sudoku_solution(Id, Puzzle), Payload),
    http_post('http://localhost:16316/problem/sudoku', json(Payload), Response, []),
    write(Response).


call_result(Relationship, FirstPerson, SecondPerson, X) :-
    call(Relationship, FirstPerson, SecondPerson),
    !,
    X = true.

call_result(_, _, _, X) :-
    X = false.