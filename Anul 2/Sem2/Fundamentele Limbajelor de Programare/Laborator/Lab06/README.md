# Lambda Calcul fără tipuri

În acest laborator vom implementa funcțiile / relațiile prezentate la curs
pentru a obține o procedură de evaluare a lambda-termenilor.

Exerciții:

1. În fișierul `Substitution.hs` implementați funcțiile

   - `freeVars` care calculează variabilele libere ale unei expresii
   - `substitute x ex e` care înlocuiește aparițiile variabilei `x` cu `ex` în `e`

2. În fișierul `Reduction.hs` implementați funcția `betaRed` care aplică un pas
   de beta-reducție folosind strategia normală, adică pe poziția cea mai din
   stânga dintre cele mai din exterior (vedeți exemplele și cursul)

3. În fișierul `Equivalence.hs` implementați funcția `alphaEquiv` care testează
   dacă două expresii date sunt alpha-echivalente.
