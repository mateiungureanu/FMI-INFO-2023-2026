sumConsec([_,_],[]).
sumConsec([_],[]).
sumConsec([],[]).
sumConsec([A,B,C|T],[M|R]) :- M is A+B+C, sumConsec([B,C|T],R).

/*
Primele 3 linii asigura ca rezultatul e [] daca lista are mai putin de 3 elemente, iar  a patra e predicatul propriu-zis, care adauga in R elementele formate din suma a cate 3 elemente consecutive din lista originala.

sumConsec([1,3,5,7],R).
R = [9, 15]

sumConsec([1,3],R).
R = []
*/


disjointX([],_).
disjointX([p(A,_)|T1],L2) :- not(member(p(A,_),L2)), disjointX(T1,L2).

/*
Prima linie asigura ca rezultatul e true daca lista L1 e goala, iar a doua linie e predicatul propriu-zis, care ia fiecare element din L1 si verifica daca NU exista un element in L2 cu acelasi X.

disjointX([p(1, 2), p(3, 4)], [p(2, 5), p(3, 4)]).
false

disjointX([p(1, 2), p(4, 4)], [p(7, 5), p(2, 4)]).
true
*/


vars(V,[V]) :- atom(V).
vars(non(X),[non(X)]) :- is_letter(X).
vars(non(X),S) :- not(is_letter(X)), vars(X,S).
vars(si(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).
vars(sau(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).
vars(imp(X,Y),S) :- vars(X,T), vars(Y,U), append(T,U,S).

is_letter(X) :- member(X,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]).

varNeg([],[]).
varNeg([H|T],[H|R]) :- not(is_letter(H)), varNeg(T,R).
varNeg([H|T],R) :- is_letter(H), varNeg(T,R).

negVars(Phi,R) :- vars(Phi,L), varNeg(L,X), length(X,R).

/*
Predicatul vars/2 este cel din laboratorul 5, dar modificat astfel: variabilele cu non(_) le ia ca atare. Predicatul is_letter/1 verifica daca X e o variabila. Predicatul varNeg/2 ia o multime de variabile si returneaza o lista doar cu variabilele cu non(_). Astfel, preidcatul negVars/2 ia o formula, intra in vars/2 si returneaza o lista cu toate variabilele ce apar, lasandu-le pe cele negate asa, apoi varNeg/2 ia respectiva lista si o elimina variabilele fara non(_), iar predicatul predefinit length/2 afla lungimea listei cu variabile negative.

negVars(non(imp(non(a), si(b, non(non(a))))), R).
R = 2

negVars(non(imp(non(a), si(non(b), non(sau(non(a),non(b)))))), R).
R = 4
*/