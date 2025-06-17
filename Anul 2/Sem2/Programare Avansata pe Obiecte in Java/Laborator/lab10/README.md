# PAO Lab 10

## Exercitiul 1 - Fire de executie

Creati o noua instanta de fir de executie folosind cele 2 modalitati: extinzand clasa Thread / implementand interfata Runnable.
Acest fir de executie va simula un student care posteaza mesaje pe un forum/chat room.

Creati un al 2-lea fir de executie care posteaza mesaje pe acelasi forum/chat room.
Porniti ambele fire de executie si afisati mesajele care au fost postate.

Modificati exemplu anterior astfel incat un fir de executie sa simuleze un student care pune o intrebare iar altul un student care raspunde.
Trebuie sa va asigurati ca mesajele sunt afisate in ordinea corecta (intrebare, apoi raspuns).
Dupa primirea raspunsului, studentul care a pus intrebarea multumeste pentru raspuns.

Folositi pentru aceasta metodele:
object.wait()
object.notify()

dintr-un context synchronized.