%%%% rules.pl -- Part 2. Write the seven predicates below.
%%%%
%%%% The grader loads the facts and given rules in cases/kb.pl before this
%%%% file, so parent/2, edge/2, elem/2, join/3, and len/2 are yours to call.
%%%% The grader scores R1, R2, and R3 separately. Finish them in order. You
%%%% keep every group you get right.
%%%%
%%%% Each stub below throws, so a check you did not reach fails with a
%%%% message that identifies the predicate. Replace the whole stub, head and
%%%% body, with your own clauses. A stub left above your clauses runs first
%%%% and throws before Prolog tries yours.

%%% R1 -- the family.

% sibling(X, Y): X and Y share a parent and are not the same person.
%
% Order matters. X \= Y succeeds only when X and Y are already bound to
% different things, so put it after the goal that binds them.
%
% find X's parent P, then every child Y of the same P, then drop the
% pair where Y is X itself.
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

% cousin(X, Y): a parent of X and a parent of Y are siblings.
%
%go up one generation from each side (PX, PY), then reuse sibling/2.
% sibling/2 already rules out PX = PY, so siblings are never cousins.
cousin(X, Y) :-
    parent(PX, X),
    parent(PY, Y),
    sibling(PX, PY).

% descendant(D, A): A is an ancestor of D.
%
% Two clauses, the mirror image of ancestor/2 in cases/kb.pl. The base
% clause reads one parent fact. The recursive clause reads one parent fact
% and then asks a smaller question.
%
%base clause, D is A's child. Recursive clause, step down from A to
% a child P, then ask whether D descends from P. The tree has no cycles,
% so every step goes one generation down and the search ends.
descendant(D, A) :-
    parent(A, D).
descendant(D, A) :-
    parent(A, P),
    descendant(D, P).

%%% R2 -- lists.

% count_of(X, List, N): X occurs N times in List. N is 0 for the empty
% list, which is your base case.
count_of(_, [], 0).
count_of(X, [X|T], N) :-
    count_of(X, T, M),
    N is M + 1.
count_of(X, [H|T], N) :-
    X \= H,
    count_of(X, T, N).

% rev(List, Reversed): Reversed holds the elements of List in the other
% order. Reverse the tail. Then use join/3 to put the head at the end.
rev([], []).
rev([H|T], R) :-
    rev(T, RT),
    join(RT, [H], R).


% last_of(List, X): X is the last element of List. The empty list has no
% last element, so last_of([], X) must fail.
last_of([X], X).
last_of([_|T], X) :-
    last_of(T, X).
    
%%% R3 -- the graph.

% route(From, To, Path): Path is the list of nodes from From to To, in
% order, following edge/2 and never visiting a node twice. A route from a
% node to itself is [From].
%
% reach_r/2 in cases/kb.pl walks the same graph and never ends, because
% the cycle a -> b -> c -> a always offers one more edge. Carry the nodes
% you visited. Refuse to step onto one again. \+ Goal is true when Goal
% cannot be proved. That is how you say "not yet visited."
route(From, To, Path) :-
    route(From, To, [From], Path).

% route(From, To, Visited, Path): Visited holds the nodes already on the
% path, so the walk never steps onto one twice and the cycle ends.
%
% clause 1 stops when the walk stands on To; the path ends [To].
% Clause 2 puts From at the front of the path, takes one edge to Next,
% skips Next if it is already visited, then walks on from Next. The path
% is built front to back, so it never needs rev/2.
route(To, To, _, [To]).
route(From, To, Visited, [From|Rest]) :-
    edge(From, Next),
    \+ elem(Next, Visited),
    route(Next, To, [Next|Visited], Rest).
