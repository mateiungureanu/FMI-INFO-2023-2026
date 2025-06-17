# PAO Lab 7

## Exercitiul 1 - Exceptii checked/verificate de compilator si unchecked (runtime)

Declarati 2 obiecte de tip Object dar omiteti sa initializati unul dintre ele.
Apelati metoda equals() pentru instanta neinitializata, pasand cea de-a doua instanta ca parametru.
Declarati o clasa Student care implementeaza metoda clone(). Dintr-o metoda main(), apelati metoda clone() pentru instanta de tipul respectiv.

## Exercitiul 2 - Tratarea exceptiilor: handle or declare

Rezolvati eroarea de compilare generata de apelul metodei clone() din clasa Student prin cele 2 metode:
- declararea exceptiei in semnatura metodei main()
- tratarea exceptiei intr-un bloc try-catch-(finally)

## Exercitiul 3 - Exceptii custom (definite de utilizator)

Modelati o clasa BankAccount cu un camp de tip int numit balance. Adaugati o metoda care retrage o suma de bani din cont. Daca fondurile sunt insuficiente, aruncati o exceptie de tip InsufficientFundsException (definita de utilizator) care extinde clasa Exception.

## Exercitiul 4 - fluxuri de intrare/iesire pentru fisiere text. Try-with-resources si interfata AutoClosable

Scrieti intr-un fisier de tip text folosing clasa FileWriter. Includeti declararea FileWriter intr-un bloc try-with-resources.
Cititi din fisierul text folosind clasa FileReader. Includeti declararea FileReader intr-un bloc try-with-resources.

## Exercitiul 5 - fluxuri de intrare/iesire pentru fisiere binare

Scrieti intr-un fisier de tip binar folosind clasa FileOutputStream. 
Ca input folositi un array de bytes obtinut din String-ul reprezentand continutul fisierului anterior.
Includeti declararea FileOutputStream intr-un bloc try-with-resources.

Cititi din fisierul binar folosind clasa FileInputStream.

## Exercitiul 6 - Fluxuri de procesare cu buffer

Scrieti un String intr-un fisier de tip text folosind clasa BufferedWriter care infasoara un FileWriter.
Cititi din fisierul text folosind clasa BufferedReader care infasoara un FileReader.

## Exercitiul 7 - Fluxuri de procesare cu buffer pentru fisiere binare

Repetati exercitiul 6 dar folosind clasele BufferedOutputStream si BufferedInputStream pentru fisiere binare.

## Exercitiul 8 - Serializare folosing DataInputStream si DataOutputStream

Scrieti un array de obiecte de tip Student intr-un fisier binar folosind clasa DataOutputStream.
Cititi din fisierul binar folosind clasa DataInputStream si recreati obiectele Student pe baza datelor citite.

## Exercitiul 9 - Fluxuri de procesare cu acces aleatoriu

Folosind RandomAccessFile, inserati dupa primul Student din fisierul binar creat la exercitiul 8 un nou Student.




