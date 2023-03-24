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