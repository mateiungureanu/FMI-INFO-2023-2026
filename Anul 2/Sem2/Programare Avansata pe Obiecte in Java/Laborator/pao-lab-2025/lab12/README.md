# PAO Lab 12

## Exercitiul 1 - JDBC

Instalati local un server MySQL, fie direct pe masina voastra, fie folosind un container Docker.

Exemplu folosind Docker si MySQL 8.0:

```bash
docker pull mysql:8.0
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=my-secret-pw -d -p 3306:3306 mysql:8.0
```

Creati un nou modul Java si adaugati dependenta pentru driverul JDBC MySQL:
- downloadati jar-ul driverului MySQL Connector/J de pe [pagina oficiala](https://dev.mysql.com/downloads/connector/j/)
- adaugati-l in modulul vostru Java (de exemplu, in directorul `lib` al proiectului si adaugati-l la classpath)

Intr-o clasa Main, realizati urmatoarele operatii - puteti urma exemplul de la MySQL - https://dev.mysql.com/doc/connector-j/en/connector-j-usagenotes-connect-drivermanager.html:
- incarcati driverul JDBC pentru MySQL folosind `Class.forName("com.mysql.cj.jdbc.Driver")`
- creati o conexiune la baza de date folosind `DriverManager.getConnection("jdbc:mysql://localhost:3306/nume_baza_de_date", "utilizator", "parola")`

## Exercitiul 2 - Operatii CRUD

Creati o baza de date 'pao' si o tabela STUDENTS in MySQL pentru a stoca informatii despre studenti. 
De exemplu, tabela poate avea urmatoarele coloane:
- id (unsigned integer, primary key, auto-increment)
- name (varchar)
- study_year (unsigned integer)
- study_group (unsigned integer)
- 
Creati o tabela GRADES pentru a stoca informatii despre notele studentilor. Un student poate avea mai multe note, deci tabela poate avea urmatoarele coloane:
- id (unsigned integer, primary key, auto-increment)
- student_id (unsigned integer, foreign key referinta la STUDENTS(id))
- subject (varchar)
- grade (unsigned integer)

Folosind JDBC Statements/PreparedStatements, implementati operatii CRUD (Create, Read, Update, Delete) pentru tabela STUDENTS:
- **Create**: Inserati mai multi studenti in tabela STUDENTS.
- **Read**: Selectati toti studentii din tabela STUDENTS si afisati-i in consola.
- **Update**: Actualizati numele unui student specificat dupa id.
- **Delete**: Stergeti toti studentii/un student specificat dupa id.

Similar, inserati mai multe note in tabela GRADES pentru fiecare student.

Declarati o functie care sa primeasca un student_id si sa returneze media generala a acelui student.
Apelati aceasta functie pentru un student specificat si afisati rezultatul in consola.

