# Lambda Calcul cu tipuri simple

În acest laborator vom implementa funcțiile / relațiile prezentate la curs
pentru a obține
- o procedură de determinare/verificare a tipurilor a la Church
- o procedura de inferență a tipurilor a la Curry

Exerciții:

1. În fișierul `TypeCheck.hs` implementați funcția `typeCheck` care calculează
   tipul unei expresii prin metoda lui Church, date fiind tipurile pentru 
   variabilele (libere sau legate) prezente în expresie.

2. În fișierul `TypeInfer.hs` implementați funcția `getConstraints` care
   acumulează constrângerile conform algoritmului prezentat în curs (funcția `c`).

   Observație: în plus față de funcția prezentată în curs, funcția noastră mai are ca
   argument mulțimea variabilelor folosite până în prezent, necesară pentru a obține
   variabile "proaspete" (fresh).
   
   Inițial aceasta conține variabilele de tip pentru variabilele libere din expresie
   și variabila corespunzătoare tipului rezultat.

   Va trebui să actualizați această mulțime pentru a vă asigura că nu este generată
   aceeași variabilă de mai multe ori.

   Dacă ați implementat corect, atunci inferența de tipuri implementată în 
   `typeInfer` ar trebui să dea rezultate asemenea celor prezentate în exemple.
