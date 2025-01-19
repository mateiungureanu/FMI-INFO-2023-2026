S6 - L5.pdf

IV. [Exerci?ii de definire tabele]
1. Sa se creeze tabelul ANGAJATI_*** (pnu se alcatuieste din prima litera din prenume 
si primele doua din numele studentului) corespunzator schemei relationale:
ANGAJATI_***(cod_ang number(4), nume varchar2(20), prenume varchar2(20), 
email char(15), data_ang date, job varchar2(10), cod_sef number(4), 
salariu number(8, 2), cod_dep number(2))
in urmatoarele moduri:
Se presupune ca valoarea implicita a coloanei data_ang este SYSDATE.
Observa?ie: Nu pot exista doua tabele cu acelasi nume in cadrul unei scheme,
deci recrearea unui tabel va fi precedata de suprimarea sa prin comanda:
DROP TABLE ANGAJATI_***;

a) fara precizarea vreunei chei sau constrangeri;

create table ANGAJATI_***(
  cod_ang number(4), 
  nume varchar2(20), 
  prenume varchar2(20), 
  email char(15), 
  data_ang date, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2), 
  cod_dep number(2)); --table ANGAJATI_*** created.
  
  select * from angajati_***; --0 rez
  drop table angajati_***; --table ANGAJATI_*** dropped.
  
b) cu precizarea cheilor primare la nivel de coloana ?i a 
constrangerilor NOT NULL pentru coloanele nume si salariu;
Se presupune ca valoarea implicita a coloanei data_ang este SYSDATE.

create table ANGAJATI_***(
  cod_ang number(4) primary key, 
  nume varchar2(20) not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2));
  
  select * from angajati_***;
    
SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati_***');
--SYS_C00527493	C	ANGAJATI_***
--SYS_C00527492	C	ANGAJATI_***
--SYS_C00527494	P	ANGAJATI_***  

--2024
--SYS_C00748555	C	ANGAJATI_***
--SYS_C00748554	C	ANGAJATI_***
--SYS_C00748556	P	ANGAJATI_***
 drop table angajati_***;
--v2
create table ANGAJATI_***(
  cod_ang number(4) constraint pk_ang_*** primary key, 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2));
  
--SYS_C00527502	C	ANGAJATI_*** --salariu
--NULL_NUME_***	C	ANGAJATI_*** --nume
--PK_ANG_***	P	ANGAJATI_***  ---cod_ang



c) cu precizarea cheii primare la nivel de tabel ?i 
a constrangerilor NOT NULL pentru coloanele nume si salariu.
Se presupune ca valoarea implicita a coloanei data_ang este SYSDATE.
;
  drop table angajati_***;

create table ANGAJATI_***(
  cod_ang number(4), 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) constraint null_salariu_*** not null, 
  cod_dep number(2),
  constraint pk_ang_*** primary key(cod_ang)
  );
  
  select * from angajati_***;

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
--where lower(constraint_name) like '%aal';
WHERE  lower(table_name) ='angajati_***';
  Observa?ie: Tipul constrangerilor este marcat prin:
  P - pentru cheie primara
  R - pentru constrangerea de integritate referentiala (cheie externa);
  U - pentru constrangerea de unicitate (UNIQUE);
  C - pentru constrangerile de tip CHECK.

--NULL_SALARIU_***	C	ANGAJATI_***
--NULL_NUME_***	C	ANGAJATI_***
--PK_ANG_***	P	ANGAJATI_***

2.	Adaugati urmatoarele inregistrari in tabelul ANGAJATI_***:

Cod_ang	Nume	Prenume	   Email	Data_ang	Job	        Cod_sef	Salariu	Cod_dep
    100	Nume1	Prenume1	Null	Null	    Director	null	20000	10
    101	Nume2	Prenume2	Nume2	02-02-2004	Inginer	    100	    10000	10
    102	Nume3	Prenume3	Nume3	05-06-2004	Analist	    101	    5000	20
    103	Nume4	Prenume4	Null	Null	    Inginer	    100	    9000	20
    104	Nume5	Prenume5	Nume5	Null	    Analist	    101	    3000	30
    
    
Prima si a patra inregistrare vor fi introduse specificand coloanele pentru care 
introduce?i date efectiv, iar celelalte vor fi inserate fara precizarea 
coloanelor in comanda INSERT.
Salva?i comenzile de inserare.

insert into angajati_***(Cod_ang,Nume,Prenume,Email,Data_ang,Job,Cod_sef,Salariu,Cod_dep) 
values( 100	,'Nume1',	'Prenume1',	Null	,Null,	'Director',	null,	20000	,10);
select * from angajati_***;

insert into angajati_***
values (101, 'Nume2','Prenume2','Nume2@gmail.com',
        to_date('02-02-2004', 'dd-mm-yyyy'), 'Inginer',	100,10000,10);
        
--insert into angajati_***
--values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', 
--        to_date('05-06-2004', 'dd-mm-yyyy'), 'Programator', 101, 5000, 20);
--ORA-12899: value too large for column "GRUPA33"."ANGAJATI_***"."JOB" (actual: 11, maximum: 10)
-- job varchar2(10)

insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', 
        to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103 

insert into angajati_***
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30);

--insert into angajati_***
--values (105, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, Null, 30);
----ORA-01400: cannot insert NULL into ("GRUPA34"."ANGAJATI_***"."SALARIU")

select * from angajati_***;
commit;

100	Nume1	Prenume1			                    Director    20000	10
101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10
102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20
103	Nume4	Prenume4		            06-APR-22	Inginer	100	9000	20
104	Nume5	Prenume5	Nume5@gmail.com		        Analist	101	3000	30

100	Nume1	Prenume1			Director		20000	10
101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10
102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20
103	Nume4	Prenume4		28-MAR-23	Inginer	100	9000	20
104	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30

100	Nume1	Prenume1			Director		20000	10
101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10
102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20
103	Nume4	Prenume4		04-APR-24	Inginer	100	9000	20
104	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30

--truncate table angajati_***;
--rollback;
--select * from angajati_***;
--
--delete from angajati_***;

3. Creati tabelul ANGAJATI10_***, prin copierea angajatilor din departamentul 10 
din tabelul ANGAJATI_***. Listati structura noului tabel. Ce se observa?

create table angajati10_*** as
  Select * from angajati_*** where cod_dep =10;
  
  select * from angajati10_***; --2 rez
  
  
SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati10_***');
--SYS_C00527544	C	ANGAJATI10_***
--SYS_C00527543	C	ANGAJATI10_***
--doar contrangerile de not null peste coloanele nume si salriu au fost copiate
desc angajati10_***;
Name     Null     Type         
-------- -------- ------------ 
COD_ANG           NUMBER(4)    --lipseste pk
NUME     NOT NULL VARCHAR2(20) 
PRENUME           VARCHAR2(20) 
EMAIL             CHAR(15)     
DATA_ANG          DATE         
JOB               VARCHAR2(10) 
COD_SEF           NUMBER(4)    
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2)    

desc angajati_***;

Name     Null     Type         
-------- -------- ------------ 
COD_ANG  NOT NULL NUMBER(4)    --este setata PK
NUME     NOT NULL VARCHAR2(20) 
PRENUME           VARCHAR2(20) 
EMAIL             CHAR(15)     
DATA_ANG          DATE         
JOB               VARCHAR2(10) 
COD_SEF           NUMBER(4)    
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2) 



4. Introduceti coloana comision in tabelul ANGAJATI_***. 
Coloana va avea tipul de date NUMBER(4,2).

alter table angajati_***
add (comision number(4,2));

select * from angajati_***;

5. Este posibila modificarea tipului coloanei comision in NUMBER(6,2)?
alter table angajati_***
modify (comision number(6,2));

--Table ANGAJATI_*** altered.

--apoi pot sa micsorez?
alter table angajati_***
modify (comision number(4,2));
--table ANGAJATI_*** altered. (toate infomatiiile din coloana comision sunt nule)

select * from angajati_***;
5-2 .	Este posibil? modificarea tipului coloanei salariu in NUMBER(6,2)?
-- SALARIU  NOT NULL NUMBER(8,2) 
alter table angajati_***
modify (salariu number(7,2));
-- SQL Error: ORA-01440: coloana de modificat trebuie sa fie goala pentru a micsora precizia sau scala

-- 6. Setati o valoare DEFAULT pentru coloana salariu.

alter table angajati_***
modify(salariu default 1111);

-- lipseste salariul si data de angajare
insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Cod_dep) 
values (105, 'Nume6', 'Prenume6', 'Inginer', 100, 20);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Cod_dep, salariu)
values (106, 'Num76', 'Prenume76', 'Inginer', 100, 20, 2222);

select * from angajati_***;

--alter table angajati_***
--drop column comission;

-- 105	Nume6	Prenume6		06-APR-22	Inginer	100	1111	20	
-- 106	Num76	Prenume76		06-APR-22	Inginer	100	2222	20	

7. Modificati tipul coloanei comision in NUMBER(2, 2) si 
al coloanei salariu in NUMBER(10,2), 
in cadrul aceleiasi instructiuni.
desc angajati_***;

-- inainte
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2)    
COMISION          NUMBER(4,2)  

alter table angajati_***
modify ( salariu number(10,2),
          comision number(2,2)
          );

-- dupa: 
SALARIU  NOT NULL NUMBER(10,2) 
COD_DEP           NUMBER(2)    
COMISION          NUMBER(2,2)       
--
--update angajati_***
--set comision= null
--where lower(job)  like 'i%';




--8. Actualiza?i valoarea coloanei comision, setand-o la valoarea 0.1 pentru 
--salariatii al caror job incepe cu litera I. (UPDATE)
--select * from angajati_***;







update angajati_***
set comision=0.1
where lower(job)  like 'i%';

select * from angajati_***;

-- atentie

update angajati_***
set comision=1.1 
where lower(job)  like 'i%';
-- ORA-01438: value larger than specified precision allowed for this column

update angajati_***
set comision=0.129345 
where lower(job)  like 'i%';

-- 100	Nume1	Prenume1			                    Director	20000	10	
-- 101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10	0.13
-- 102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20	
-- 103	Nume4	Prenume4		            06-APR-22	Inginer	100	9000	20	0.13
-- 104	Nume5	Prenume5	Nume5@gmail.com             Analist	101	3000	30	
-- 105	Nume6	Prenume6		            06-APR-22	Inginer	100	1111	20	0.13
-- 106	Num76	Prenume76		            06-APR-22	Inginer	100	2222	20	0.13

12. Redenumiti tabelul ANGAJATI_*** in ANGAJATI3_***.
rename angajati_*** to angajati3_***; 
-- angajati_*** TO succeeded.
select * from angajati_***; -- ORA-00942: tabelul sau vizualizarea nu exista
select * from angajati3_***; 
desc angajati3_***;

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati3_***');



13. Consultati vizualizarea TAB din dictionarul datelor. Redenumiti angajati3_*** in angajati_***.
select * from tab;
rename angajati3_*** to angajati_***;
--Table renamed.
select * from angajati_***;
select * from angajati3_***;  --ORA-00942: tabelul sau vizualizarea nu exista



14. Suprimati continutul tabelului angajati10_***, fara a suprima structura acestuia.

create table angajati10_*** as
  Select * from angajati_*** where cod_dep =10;
  
  select * from angajati10_***;
  
  delete from angajati10_***; --tabela goala
  rollback; -- avem cele 2 inregistrari
  
  truncate table angajati10_***; --se pastreaza structura tabelei (DELETE+COMMIT)
  rollback; -- in continuare tabela este goala
  
  drop table angajati10_***;
  select * from angajati10_***; -- ORA-00942: tabelul sau vizualizarea nu exista
  
-- 15. Creati tabelul DEPARTAMENTE_***, corespunzator schemei relationale:
-- DEPARTAMENTE_*** (cod_dep# number(2), nume varchar2(15), cod_director number(4))
-- specificand doar constrangerea NOT NULL pentru nume
-- (nu precizati deocamdata constrangerea de cheie primara). 

drop table departamente_***;

CREATE TABLE departamente_*** 
(cod_dep number(2), 
nume varchar2(15) constraint NL_nume_*** NOT NULL, 
cod_director number(4)); 

DESC departamente_***;

/*
Name         Null     Type         
------------ -------- ------------ 
COD_DEP               NUMBER(2)    
NUME         NOT NULL VARCHAR2(15) 
COD_DIRECTOR          NUMBER(4)   

16. Introduceti urmatoarele inregistrari in tabelul DEPARTAMENTE_pnu:
Cod_dep	Nume	Cod_director
10	Administrativ	100
20	Proiectare	101
30	Programare	Null
*/

insert into departamente_***
values(10,	'Administrativ',	100);
insert into departamente_***
values(20, 'Proiectare',	101);
insert into departamente_***
values(30,	'Programare',	Null);

-- atentie
insert into departamente_***
values(30,	'DE_STERS',	Null);

select * from departamente_***;
/*
10	Administrativ	100
20	Proiectare	101
30	Programare	
30	DE_STERS	
*/

alter table departamente_***
add constraint pk_depart_*** primary key (cod_dep); 

-- SQL Error: ORA-02437: (GRUPA32.PK_DEPART_***) nu a putut fi validata - cheia primara a fost violata
--*Cause:    attempted to validate a primary key with duplicate values or null
--           values.
--*Action:   remove the duplicates and null values before enabling a primary
--           key.
;
delete from departamente_***
where nume = 'DE_STERS'; -- 1 rows deleted.

select * from departamente_***;
--commit;
--setam la urm ex aceasta constrangere
17. Introduce?i constangerea de cheie primara asupra coloanei cod_dep,
fara suprimarea si recrearea tabelului 
(comanda ALTER).
Observa?ie:
o Introducerea unei constrangeri dupa crearea tabelului presupune ca toate liniile existente in tabel la 
momentul respectiv satisfac noua constrangere.
o Specificarea constrangerilor permite numirea acestora.
o In situatia in care constrangerile sunt precizate la nivel de coloana sau tabel 
(in CREATE TABLE) ele vor primi implicit nume atribuite de sistem, daca nu se specifica vreun alt nume 
intr-o clauza CONSTRAINT.
Exemplu : CREATE TABLE alfa (
X NUMBER CONSTRAINT nn_x NOT NULL,
Y VARCHAR2 (10) NOT NULL
);

-- atentie
alter table departamente_***  --PK = Unique + NOT NULL
add constraint pk_depart_*** primary key (cod_director);
--SQL Error: ORA-01449: coloana contine valori NULL; nu se poate modifica in NOT NULL

--corect
alter table departamente_***
add constraint pk_depart_*** primary key (cod_dep); 

--table DEPARTAMENTE_*** altered.

--alter table departamente_***
--drop constraint pk_depart_***;


desc departamente_***;

--Name         Null?    Type         
-------------- -------- ------------ 
--COD_DEP      NOT NULL NUMBER(2)    
--NUME         NOT NULL VARCHAR2(15) 
--COD_DIRECTOR          NUMBER(4)  

18. Sa se precizeze constrangerea de cheie externa pentru coloana cod_dep din ANGAJATI_pnu:
a) fara suprimarea tabelului (ALTER TABLE);

desc angajati_***;

select * from angajati_***;

--delete from angajati_***
--where cod_ang in (105,106);


alter  table angajati_***
add  constraint fk_ang_depart_*** foreign key(cod_dep) references departamente_***(cod_dep);

--Posibile erori:
-- ORA-02270: no matching unique or primary key for this column-list (pt ca nu este setata cheia primara pe tabela de departamente

--ORA-02298: cannot validate (GRUPA34.FK_ANG_DEPART_***) - parent keys not found
--02298. 00000 - "cannot validate (%s.%s) - parent keys not found"
-- angajatii lucreaza pe departamente care nu se gasesc in tabela departamente_***
--insert  into angajati_***
--values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', Null, 'Analist', 101, 3000, 50, 0.2);
--delete from angajati_***
--where cod_ang =105;

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) = 'angajati_***';

NULL_SALARIU_***	C	ANGAJATI_***
NULL_NUME_***	C	ANGAJATI_***
FK_ANG_DEPART_***	R	ANGAJATI_*** --FK
PK_ANG_***	P	ANGAJATI_***  --PK

b) prin suprimarea si recrearea tabelului, cu precizarea noii constrangeri la nivel de coloana 
({DROP, CREATE} TABLE). De asemenea, se vor mai preciza constrangerile (la nivel de coloana, 
in masura in care este posibil):
- PRIMARY KEY pentru cod_ang;
- FOREIGN KEY pentru cod_sef;
- UNIQUE pentru combinatia nume + prenume;
- UNIQUE pentru email;
- NOT NULL pentru nume;
- verificarea cod_dep > 0;
- verificarea ca salariul sa fie mai mare decat comisionul*100.

--drop table departamente_***; --SQL Error: ORA-02449: cheile unice/primare din tabela sunt referite de cheile externe

drop table angajati_***; --table ANGAJATI_*** dropped.

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) = 'departamente_***';

create table ANGAJATI_***(
  cod_ang number(4) constraint pk_ang_*** primary key, 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15) constraint unq_email_*** unique, 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4) constraint fk_ang_ang_*** references angajati_***(cod_ang), 
  salariu number(8, 2),
  cod_dep number(2) constraint ck_cod_dep_*** check(cod_dep>0), 
  comision number(4,2),
  constraint unq_nume_pren_*** unique(nume, prenume),
  constraint ck_sal_com_*** check( salariu>comision *100),
  constraint fk_ang_depart_*** foreign key(cod_dep) references departamente_***(cod_dep)--se poate punse si la nivel de coloana
    );


SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati_***');

CK_SAL_COM_***	C	ANGAJATI_***
CK_COD_DEP_***	C	ANGAJATI_***
NULL_NUME_***	C	ANGAJATI_***
FK_ANG_DEPART_***	R	ANGAJATI_***
FK_ANG_ANG_***	R	ANGAJATI_***
UNQ_NUME_PREN_***	U	ANGAJATI_***
UNQ_EMAIL_***	U	ANGAJATI_***
PK_ANG_***	P	ANGAJATI_***

19. Suprimati si recreati tabelul, specificand toate constrangerile la nivel de tabel 
(in masura in care este posibil).
/

drop table angajati_***;

create  table ANGAJATI_***(
  cod_ang number(4) , 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15) , 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4) , 
  salariu number(8, 2),
  cod_dep number(2) ,
  comision number(4,2),
  constraint unq_nume_pren_*** unique(nume, prenume),
  constraint ck_sal_com_*** check(salariu>comision *100),
  constraint pk_ang_*** primary key(cod_ang),
  constraint unq_email_*** unique(email),
  constraint fk_ang_ang_*** foreign key(cod_sef) references angajati_***(cod_ang),
  constraint ck_cod_dep_*** check(cod_dep>0),
  constraint fk_ang_depart_*** foreign key(cod_dep) references departamente_***(cod_dep)  
    );
    
    drop table ANGAJATI_***;

  SELECT * FROM USER_CONSTRAINTS WHERE lower(TABLE_NAME) = 'angajati_***';

CK_COD_DEP_***	C
CK_SAL_COM_***	C
NULL_NUME_***	C
FK_ANG_DEPART_***	R
FK_ANG_ANG_***	R
UNQ_EMAIL_***	U
UNQ_NUME_PREN_***	U
PK_ANG_***	P
select * from angajati_***;

insert into angajati_***(Cod_ang,	Nume	,Prenume,	Email,	Data_ang	,Job,	Cod_sef,	Salariu,	Cod_dep)
values( 100	,'Nume1',	'Prenume1',	Null	,Null,	'Director',	null,	20000	,10);


insert into angajati_***
values (101, 	'Nume2',	'Prenume2',	'Nume2@gmail.com', to_date(	'02-02-2004', 'dd-mm-yyyy'), 	'Inginer',	100,	10000	,10, 0.1);

insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20, null);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103 

insert into angajati_***
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);

select * from angajati_***;
commit;

delete from angajati_***;
rollback;

insert into angajati_***  --inserare prin copiere din tabela mea
select * from angajati_***;
-----
insert into angajati_***(Cod_ang, Nume ,Prenume, Email, Data_ang ,Job, Cod_sef, Salariu, Cod_dep)
values( 100 ,'Nume1', 'Prenume1', Null ,Null, 'Director', null, 20000 ,10);
select * from angajati_***;
insert into angajati_***
values (101, 'Nume2', 'Prenume2', 'Nume2@gmail.com', to_date( '02-02-2004', 'dd-mm-yyyy'), 'Inginer', 100, 10000 ,10, 0.1);
insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20, null);
insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103
insert into angajati_***
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
-----------
commit;


select * from departamente_***;



25. (incercati sa) adaugati o noua inregistrare in tabelul ANGAJATI_pnu, 
care sa corespunda codului de departament 50. Se poate?


insert  into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', Null, 'Analist', 101, 3000, 50, 0.2);
SQL Error: ORA-02291: constrangere de integritate (GRUPA33.FK_ANG_DEPART_***) violata - cheia parinte negasita
--dept 50 nu exista in lista de departamente

--atentie
insert into angajati_***
values (105, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
--SQL Error: ORA-00001: restrictia unica (GRUPA34.UNQ_NUME_PREN_***) nu este respectata

insert  into angajati_***
values (105, 'Nume6', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
--SQL Error: ORA-00001: restrictia unica (GRUPA34.UNQ_EMAIL_***) nu este respectata


29. (incercati sa) introduceti un nou angajat, specificand valoarea 114 pentru cod_sef.
Ce se obtine?

insert into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', null, 'Analist', 114, 3000, 20, 0.2);

--SQL Error: ORA-02291: constrangere de integritate (GRUPA33.FK_ANG_ANG_***) violata - cheia parinte negasita

--angajatul 114 nu exista in baza de date
30. Adaugati un nou angajat, avand codul 114. incercati din nou introducerea inregistrarii de la exercitiul 29.

insert into angajati_***
values (114, 'Nume7', 'Prenume7', 'Nume7@gmail.com', null, 'Analist', 100, 3000, 20, 0.2); --1 rows inserted.

insert into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', null, 'Analist', 114, 3000, 20, 0.2); --1 rows inserted.

select * from angajati_***;

21. Ce se intampla daca se incearca suprimarea tabelului departamente_pnu?

drop table departamente_***; 
--SQL Error: ORA-02449: cheile unice/primare din tabela sunt referite de cheile externe
truncate table departamente_***; 
--SQL Error: ORA-02266: cheile unice/primare din tabela sunt referite de cheile externe activate
delete from departamente_***; 
--SQL Error: ORA-02292: constrangerea de integritate (GRUPA33.fk_ang_depart_***) violata - gasita inregistrarea copil

26. Adaugati un nou departament, cu numele Testare, codul 60 si directorul null in DEPARTAMENTE_pnu. COMMIT.
insert into departamente_***
values(60,	'Testare',	null); --1 rows inserted.
commit;

27. (incercati sa) stergeti departamentul 20 din tabelul DEPARTAMENTE_pnu. Comentati.
delete from departamente_***
where cod_dep =20;
--SQL Error: ORA-02292: constrangerea de integritate (GRUPA34.fk_ang_depart_***) violata - gasita inregistrarea copil
--lucreaza angajati in dept 20
select * from angajati_***
where cod_dep =20;
--4 rez

28. Stergeti departamentul 60 din DEPARTAMENTE_pnu. ROLLBACK.

select * from departamente_***;
delete from departamente_***
where cod_dep =60; --1 rows deleted.
commit;

31. Se doreste stergerea automata a angajatilor dintr-un departament, odata cu suprimarea departamentului.
Pentru aceasta, este necesara introducerea clauzei ON DELETE CASCADE in definirea constrangerii de cheie externa.
Suprimati constrangerea de cheie externa asupra tabelului ANGAJATI_pnu si reintroduceti aceasta constrangere, 
specificand clauza ON DELETE CASCADE.

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('departamente_***', 'angajati_***');

--sterg vechea constrangere FK dintre tabela angajati si cea de departamente
alter table angajati_***
drop constraint FK_ANG_DEPART_***;
--table ANGAJATI_*** altered.


--adaug FK intre tabela angajati si cea de departamente
alter table angajati_***
add constraint FK_ANG_DEPART2_*** foreign key(cod_dep) 
            references departamente_***(cod_dep) on delete cascade;

32. Stergeti departamentul 20 din DEPARTAMENTE_pnu. Ce se intampla? Rollback.

select * from angajati_***;
-- 7 rez, dintre care 4 lucreaza in dept 20
-- exista angajati care lucreaza in dept 20

delete from departamente_*** 
where cod_dep =20;
--1 rows deleted.

select * from angajati_***;
--3 rez

rollback;
select * from angajati_***; --7 rez
select * from departamente_***; --3 rez
--commit;

-- ON DELETE SET NULL

alter table angajati_***
drop constraint FK_ANG_DEPART2_*** ;
--table ANGAJATI_*** altered.

alter table angajati_***
add constraint fk_depart_***3 foreign key(cod_dep) 
        references departamente_***(cod_dep) on delete set null;


select * from angajati_***;
-- 7 rez, dintre care 4 lucreaza in dept 20

delete from departamente_*** 
where cod_dep =20;
--1 rows deleted.

select * from departamente_***;

select * from angajati_***;
--7 rez, cei care lucrau in dept 20, acum au dept setata null

rollback;

------  V. [Definirea secven?elor]  -------


CREATE SEQUENCE nume_secv
[INCREMENT BY n]
[START WITH n]
[{MAXVALUE n | NOMAXVALUE}]
[{MINVALUE n | NOMINVALUE}]
[{CYCLE | NOCYCLE}]
[{CACHE n | NOCACHE}];

/*
38. Creati o secventa pentru generarea codurilor de departamente, SEQ_DEPT_PNU. 
Secventa va incepe de la 400, va creste cu 10 de fiecare data si va avea valoarea maxima 
10000, nu va cicla si nu va incarca nici un numar inainte de cerere.
*/

drop sequence   seq_dept_***;

create  sequence seq_dept_***
start with 400
increment by 10
maxvalue 10000
nocycle
nocache;
--Sequence SEQ_DEPT_*** created.

select seq_dept_***.nextval
from dual;

--I -> 400
--II ->410

select seq_dept_***.currval
from dual;

insert into departamente_***
values(seq_dept_***.nextval, 'Dept_sec', null);  --420
--SQL Error: ORA-01438: valoare mai mare decat precizia specificata permisa pentru aceasta coloana

desc departamente_***;
Name         Null     Type         
------------ -------- ------------ 
COD_DEP      NOT NULL NUMBER(2)    
NUME         NOT NULL VARCHAR2(15) 
COD_DIRECTOR          NUMBER(4)    

--create table dept_***
--as select * from departments;

insert into dept_***
values(seq_dept_***.nextval, 'Dept_sec', null, null); 
--1 rows inserted.
select * from dept_***;
--430	Dept_sec		null null
--440	Dept_sec		null null 

delete from dept_***
where department_id between 430 and 510;
commit;

rollback;

--extra
--delete from dept_***
--where (department_id between 200 and 230 or
-- department_id between 260 and 290 )
--and mod(department_id, 3) =0;

40. Creati o secventa pentru generarea codurilor de angajati, SEQ_EMP_PNU.

drop sequence seq_ang_***;

create sequence seq_ang_***
start with 100
maxvalue 120 --- ca sa apara o eroare cand ajunge la maxvalue
nocycle
nocache;

41. Sa se modifice toate liniile din angajati_*** (daca nu mai exista, il recreati),
regenerand codul angajatilor astfel incat sa utilizeze secventa SEQ_EMP_PNU si 
sa avem continuitate in codurile angajatilor.

update angajati_***  --7 ang
set cod_ang = seq_ang_***.nextval; --(100..106)
--SQL Error: ORA-02292: constrangerea de integritate (GRUPA34.FK_ANG_ANG_***) violata - gasita inregistrarea copil

select * from angajati_***;

delete from angajati_***
where cod_ang =105; --nu rezolva problema
commit;

update angajati_*** --6 ang
set cod_ang = seq_ang_***.nextval; --(107---112)
--SQL Error: ORA-02292: constrangerea de integritate (GRUPA34.FK_ANG_ANG_***) violata - gasita inregistrarea copil

--rezolvare:
update angajati_***
set cod_sef = null;
6 rows updated.

--dupa 2 update-uri esuate am ajuns la val 113

update angajati_***
set cod_ang = seq_ang_***.nextval;
6 rows updated.

--113	Nume1	Prenume1			Director		20000	10	
--114	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer		10000	10	0,1
--115	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist		5000		
--116	Nume4	Prenume4		15-04-2021	Inginer		9000		
--117	Nume5	Prenume5	Nume5@gmail.com		Analist		3000	30	0,2
--118	Nume7	Prenume7	Nume7@gmail.com		Analist		3000		0,2


---incerc sa mai fac un update, dar atimge val maxima
ORA-08004: sequence SEQ_ANG_***.NEXTVAL exceeds MAXVALUE and cannot be instantiated


rollback;
--
--100	Nume1	Prenume1			Director		20000	10	
--101	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer	100	10000	10	0,1
--102	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist	101	5000		
--103	Nume4	Prenume4		14-04-2021	Inginer	100	9000		
--104	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30	0,2
--114	Nume7	Prenume7	Nume7@gmail.com		Analist	100	3000		0,2


--modific codul unui angajat care nu este sef -> se poate
update angajati_*** 
set cod_ang = seq_ang_***.nextval
where cod_ang =104;

--100	Nume1	Prenume1			Director		20000	10	
--101	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer	100	10000	10	0,1
--102	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist	101	5000		
--103	Nume4	Prenume4		15-04-2021	Inginer	100	9000		
--119	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30	0,2
--114	Nume7	Prenume7	Nume7@gmail.com		Analist	100	3000		0,2
Stergeti toate secventele si toate tabelele create dupa finalizarea acestui Laborator5.pdf