# Unificare

În fișerul [`Unification.hs`](Unification.hs) implementați funcția 'unifyStep'
folosindu-vă de ideile prezentate în curs.

Dacă implementați funcția cum trebuie, ar trebui ca rezultatele să fie asemănătoare cu cele
incluse în testele incluse.

Notă asupra implementării de referință:

Diferit față de algoritmul din curs, regula de eliminare este implementată doar pentru `x = x`, unde `x` este variabilă.  Se poate observa ușor că această implementare e suficientă chiar dacă poate nu la fel de eficientă ca număr de pași executați.

Constrângere:

Implementarea trebuie să folosească o noțiune abstractă de substituție ale cărei
capabilități sunt descrise de clasa Haskell `SubstitutionLike`.
