# PAO Lab 11

## Exercitiul 1 - Streams

Modelati o clasa Book cu urmatoarele atribute:
- title
- author
- publicationYear
- genre
- price
Creati o lista cu 5-10 carti de tip Book. 

Folosind Streams API, implementati urmatoarele operatii:
- creati o noua colectie cu toate cartile publicate dupa 2010 folosind filter()
- creati un Map cu genurile distincte si lista titulurilor de carti pentru fiecare gen folosind collect(Collectors.groupingBy())
- sortati cartile dupa pret in ordine descrescatoare folosind sorted() si collect(Collectors.toList())
- listati toti autorii distincti folosind map() si distinct()
- intoarceti pretul total al cartilor din lista folosind map() si reduce()
- intoarceti cea mai scumpa carte din lista (fara a folosi sortare) folosind reduce()