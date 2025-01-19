rodd([],_,[]).
rodd([H|T],N,[H|R]) :- M is N+1, estepar(N), rodd(T,M,R).
rodd([_|T],N,R) :- M is N+1, not(estepar(N)), rodd(T,M,R).

estepar(0).
estepar(1) :- false.
estepar(X) :- X>1, Y is X-2, estepar(Y).

removeOdd(L,R) :- rodd(L,0,R).



maxim(A,B,B) :- B>A.
maxim(A,B,A) :- A>=B.

mergePts([],[],[]).
mergePts([],R,R).
mergePts(R,[],R).
mergePts([p(A,B)|T1],[p(C,D)|T2],[p(C,D)|R]) :- maxim(A,C,A), A \== C, mergePts([p(A,B)|T1],T2,R).
mergePts([p(A,B)|T1],[p(C,D)|T2],[p(A,B)|R]) :- maxim(A,C,C), mergePts(T1,[p(C,D)|T2],R).
mergePts([p(A,B)|T1],[p(C,D)|T2],[p(C,D)|R]) :- A == C, maxim(B,D,B), B \== D, mergePts([p(A,B)|T1],T2,R).
mergePts([p(A,B)|T1],[p(C,D)|T2],[p(A,B)|R]) :- A == C, maxim(B,D,D), mergePts(T1,[p(C,D)|T2],R).
mergePts([p(A,B)|T1],[p(C,D)|T2],[p(A,B),p(C,D)|R]) :- A == C, B == D, mergePts(T1,T2,R).



noDuplicateVar(Phi) :- vars(Phi,S), remove_duplicates(S,R), S==R.

vars(V,[V]) :- atom(V).
vars(non(X),S) :- vars(X,S).
vars(si(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).
vars(sau(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).
vars(imp(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).


remove_duplicates([],[]).
remove_duplicates([H|L],M) :- remove_duplicates(L,M), member(H,M).
remove_duplicates([H|L],[H|M]) :- remove_duplicates(L,M), not(member(H,M)).