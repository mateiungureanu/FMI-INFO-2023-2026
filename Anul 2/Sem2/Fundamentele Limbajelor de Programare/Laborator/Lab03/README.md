# Cea mai slabă precondiție

În țara programării sigure, zmeul cel rău a furat mecanismul care calcula cea
mai slabă precondiție, parte a măreței mașini de verificare a corectitudinii
(parțiale) a programelor.

Împăratul e răvășit, prințesa s-a îmbolnăvit de tristețe, iar breasla
verificatorilor este pe cale să se revolte.

Mecanismul s-a furat, dar urmele sale au rămas. Slujba voastră este să rescrieți
partea de cod care lipsește.

Dacă reușiți, prințesa e salvată, zmeul moare de necaz, și mașina de verificare
poate fi folosită (din nou) să verifice alte programe.

## Descriere generală a programului

Programul se compilează cu

```
ghc Main.hs -o lab3
```

Programul acceptă ca intrare o aserțiune Hoare de forma `{ P } S { Q }`, unde

- `P` și `Q` sunt expresii booleene
- `S` este o sevcență de instrucțiuni în care buclele `while` sunt adnotate
  cu invarianți.

  Exemple puteți găsi în directorul `tests`, de exemplu
  [`tests/test7.exp`](tests/test7.exp) sau [`tests/test8.exp`](tests/test8.exp)

În afară de fișierul care conține programul, programul mai primește ca argument
o comandă, care poate fi `vc`, `smt`, sau `check`

- `vc` - calculează condiția de verificare, adică implicațiile care trebuie
  verificate pentru a ne asigura că aserțiunea Hoare e corectă
- `smt` - neagă condiția de verificare și o transformă în formatul
  [`SMT-LIB`](https://smt-lib.org/) care e folosit de cam toate verificatoarele
  automate de propoziții logice (care folosesc aritmetică / alte teorii)
- `check` - trimite condiția in format SMT-LIB către verificatorul `z3`
  (trebuie să îl aveți instalat și accesibil în `PATH` pentru a funcționa)
  - Dacă acesta întoarce `unsat` înseamnă că aserțiunea Hoare a fost verificată
  - Dacă nu, va da niște valori inițiale pentru variabilele de program
    pentru care aserțiunea Hoare nu este validă.


## Cerință: calcularea pre-condiției (celei mai slabe?)

Implementați funcția `wlp` din fișierul [`WeakPre.hs`](WeakPre.hs).

În principiu calculul pre-condiției urmează definiția din cursul 4, cu
excepția instrucțiunii `while`.

Dacă am implementa pre-condiția pentru `while` ca în curs
(e foarte posibil, așa fac cei de la seria 25), calculul pre-condiției ar lua
la fel de mult cât execuția efectivă a buclei, deci este foarte posibil să nu
se termine pentru majoritatea testelor posibile.

Ca să evităm asta, vom folosi invarianții (de aceea cerem ca fiecare buclă să
fie adnotată cu invarianți).
În acest scenariu, vom folosi chiar invariantul dat pe post de pre-condiția
calculată a buclei, însă _nu putem avea încredere în corectitudinea invariantului_.

Să zicem că trebuie să calculăm `wlp(while b do S invariant A, B)`

Ca să acceptăm că rezultatul este `A`, trebuie să verificăm că el e valid conform
regulii pentru `while` din logica Hoare care zice:

_Dacă `{A /\ b} S {A}`, atunci `{A} while b do S {A /\ ~ b}`._

Trebuie să ne asigurăm, deci, de două lucruri:

- putem calcula `wlp(S, A)`, dar trebuie să validăm că `A /\ b -> wlp(S, A)`
- trebuie să validăm că `A /\ ~ b -> B`

Pentru a putea acumula aceste condiții suplimentare, tipul de date pentru
rezultatul lui `wlp`, `Condition`, este o structură care conține pe lângă
câmpul care calculează pre-condiția, `condition` și un câmp `goals` care
acumulează aceste implicații descrise mai sus.

```hs
data Condition = Condition { condition :: BExpr, goals :: Maybe BExpr }
```

Pentru crearea condițiilor și acumularea lor puteți să vă folosiți de
orice este definit în modulul [`Syntax,hs`](Syntax.hs), în particular:

- `subst` (substituția) care e definită atât pentru expresii aritmetice cât și
  pentru expresii booleene
- `implies` implicația între două expresii booleene, definită ca operator derivat
- Instanța de monoid (si semigrup) definită pentru `BExpr` care ne ajută să
  acumulăm conjuncții de expresii booleene
  (folosind și că [`Maybe` are instanță de monoid](https://hackage.haskell.org/package/ghc-internal-9.1201.0/docs/src/GHC.Internal.Base.html#line-853))

## Cerință: Reparați aserțiunea pentru [`test8.exp`](tests/test8.exp)

Dacă totul merge cum trebuie, ar trebui ca toate aserțiunile din testele date
să poată fi verificate, cu excepția lui `test8.exp` unde (dacă executați cu
comanda `check`) ar trebui să primiți un exemplu de intrare pentru care
aserțiunea nu ține. Corectați aserțiunea pentru a obține una validă
(și cât mai generală, totuși).