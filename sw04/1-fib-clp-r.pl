:- use_module(library(clpr)).

% Ausgangslage fib normal (klappt nicht in beide Richtungen)
% Weil is/2 darf keine "Unbekannte" im Therm haben
fib(0, 0).
fib(1, 1).
fib(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fib(N1, F1),
    fib(N2, F2),
    F is F1 + F2.

% Vorbedingungen / Simple Cases
fib_clp(N, F) :- { N = 0, F = 0 }.
fib_clp(N, F) :- { N = 1, F = 1 }.

% Rekursive Implementation
fib_clp(N, F) :-
    { N >= 2, F = F1+F2, N1 = N-1, N2 = N-2 },
    fib_clp(N1, F1),
    fib_clp(N2, F2).

% a) Siehe Beispiel: fib_clp(N, 4).
% Das Programm terminiert nicht

% b) Stack limit exceeded -> unendliche Rekursion/Lösungssuche bis Error/Abbruch durch Stack-Limit

% c) Weitere Bedingungen sind nötig:
%    - Reihenfolge der letzten beiden Prädikate vertauschen, sodass der terministische Fall N2=N-2 (früher näher an 1 als N-1) auch früher ausgewertet wird.
%      Für N=1 existiert nämlich immer nur eine Lösung und die Suche nach einer weiteren Lösung schlägt fehl.
%    - Constraints für F1 und F2 erweitern
% Vorbedingungen / Simple Cases
fib_clpr(N, F) :- { N = 0, F = 0 }.
fib_clpr(N, F) :- { N = 1, F = 1 }.
fib_clpr(N, F) :-
    { N >= 2, F = F1 + F2, F1 > 0, F2 >= 0, F1 >= F2, N1 = N - 1, N2 = N - 2 },
    fib_clpr(N2, F2),
    fib_clpr(N1, F1).