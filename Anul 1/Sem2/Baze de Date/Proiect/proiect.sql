--10.
drop sequence secventa_cinema;
drop sequence secventa_angajat;
drop sequence secventa_sala;
drop sequence secventa_film;
drop sequence secventa_achizitie;
drop table curata;
drop table bilete;
drop table achizitii;
drop table difuzari;
drop table filme;
drop table sali;
drop table ingrijitori;
drop table casieri;
drop table angajati;
drop table cinemauri;

create sequence secventa_cinema
start with 101;
create sequence secventa_angajat
start with 101;
create sequence secventa_sala
start with 101;
create sequence secventa_film
start with 101;
create sequence secventa_achizitie
start with 100001;

create table cinemauri (
    id_cinema number(3) default secventa_cinema.nextval primary key,
    nume_cinema varchar2(50) not null,
    oras varchar2(50) not null
);

create table angajati (
    id_angajat number(3) default secventa_angajat.nextval primary key,
    nume varchar2(20) not null,
    prenume varchar2(20) not null,
    email varchar2(50) unique,
    nr_telefon number (9) unique,
    salariu number(4) default 4000 not null,
    pct_comision number(1,1) default 0 not null,
    data_angajarii date not null,
    id_sef number(3),
    id_cinema number(3) not null references cinemauri(id_cinema) on delete cascade
);

create table casieri (
    id_angajat number(3) primary key references angajati(id_angajat) on delete cascade 
);

create table ingrijitori (
    id_angajat number(3) primary key references angajati(id_angajat) on delete cascade 
);

create table sali (
    id_sala number(3) default secventa_sala.nextval primary key,
    id_cinema number(3) not null references cinemauri(id_cinema) on delete cascade 
);

create table filme (
    id_film number(3) default secventa_film.nextval primary key,
    nume_film varchar2(100) not null,
    durata number(3),
    rating number(2,1),
    regizor varchar2(100),
    anul_lansarii number(4)
);

-- problema cu TIME, am pus varchar2(5) in loc
create table difuzari (
    data date,
    ora varchar2(5),
    id_sala number(3) references sali(id_sala) on delete cascade ,
    id_film number(3) references filme(id_film) on delete cascade ,
primary key (data, ora, id_sala, id_film)
);

create table achizitii (
    id_achizitie number(6) default secventa_achizitie.nextval primary key,
    email varchar2(100),
    nr_telefon number(9)
);

-- problema cu TIME, am pus varchar2(5) in loc
create table bilete (
    rand number(2),
    coloana number(2),
    data date,
    ora varchar2(5),
    id_sala number(3),
    id_film number(3),
    id_achizitie number(6) default secventa_achizitie.currval not null references achizitii(id_achizitie) on delete cascade ,
    id_angajat number(3) not null references casieri(id_angajat) on delete cascade ,
primary key (rand, coloana, data, ora, id_sala, id_film),
foreign key (data, ora, id_sala, id_film) references difuzari(data, ora, id_sala, id_film) on delete cascade 
);

create table curata (
    id_angajat number(3) references ingrijitori(id_angajat) on delete cascade ,
    id_sala number(3) references sali(id_sala) on delete cascade ,
primary key(id_angajat, id_sala)
);

--11.
insert into cinemauri (nume_cinema, oras)
values ('Chitcan', 'Bucuresti');
insert into cinemauri (nume_cinema, oras)
values ('Sobolan', 'Bucuresti');
insert into cinemauri (nume_cinema, oras)
values ('Soparlan', 'Bucuresti');
insert into cinemauri (nume_cinema, oras)
values ('Carcalac', 'Cluj');
insert into cinemauri (nume_cinema, oras)
values ('Popandau', 'Brasov');
insert into cinemauri (nume_cinema, oras)
values ('Harciog', 'Constanta');
insert into cinemauri (nume_cinema, oras)
values ('Mangusta', 'Timisoara');


insert into angajati (prenume, nume, email, nr_telefon, salariu, pct_comision, data_angajarii, id_cinema)
values ('PersonA', 'PersonAA', 'persona@gmail.com', 111111111, 7000, 0.7, '19-AUG-2017', 101);

insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonB', 'PersonBB', 222222222, 5000, 0.5, '12-MAY-2018', 101, 101);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, email, data_angajarii, id_sef, id_cinema)
values ('Alex', 'Alexandrescu', 'alexalexandrescu@yahoo.com', '20-JUN-2018', 102, 101);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Bogdan', 'Bogdanescu', '3-JUL-2018', 102, 101);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);

insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonC', 'PersonCC', 333333333, 5000, 0.4, '7-JUL-2019', 101, 102);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Cornel', 'Corneleanu', '14-JUL-2019', 105, 102);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, email, data_angajarii, id_sef, id_cinema)
values ('David', 'Davidov', 'david_ov@gmail.com', '19-JUL-2019', 105, 102);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);

insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonD', 'PersonDD', 444444444, 5000, 0.3, '14-OCT-2019', 101, 103);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Eugen', 'Eugenescu', '27-OCT-2019', 108, 103);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Florin', 'Florescu', '30-OCT-2019', 108, 103);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);

insert into angajati (prenume, nume, email, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonE', 'PersonEE', 'persone@gmail.com', 555555555, 5000, 0.2, '2-AUG-2020', 101, 104);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, email, data_angajarii, id_sef, id_cinema)
values ('Gigel', 'Gigelovici', 'gigelovici.gigel@gmail.com', '3-AUG-2020', 111, 104);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Horia', 'Horienescu', '7-AUG-2020', 111, 104);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);

insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonF', 'PersonFF', 666666666, 5000, 0.1, '29-JUL-2020', 101, 105);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, email, data_angajarii, id_sef, id_cinema)
values ('Ion', 'Ionescu', 'ion_ionescu@yahoo.com', '5-AUG-2020', 114, 105);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Lucian', 'Lucescu', '14-AUG-2020', 114, 105);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);

insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonG', 'PersonGG', 777777777, 5000, 0.1, '1-JAN-2021', 101, 106);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Matei', 'Mateiescu', '10-JAN-2021', 117, 106);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Nicolas', 'Nicolovici', '11-JAN-2021', 117, 106);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);


insert into angajati (prenume, nume, nr_telefon, salariu, pct_comision, data_angajarii, id_sef, id_cinema)
values ('PersonH', 'PersonHH', 888888888, 5000, 0.1, '16-DEC-2021', 101, 107);
insert into casieri (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Octavian', 'Octavu', '21-DEC-2021', 120, 107);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);
insert into angajati (prenume, nume, data_angajarii, id_sef, id_cinema)
values ('Radu', 'Raduleanu', '3-JAN-2022', 120, 107);
insert into ingrijitori (id_angajat)
values (secventa_angajat.currval);


insert into sali (id_cinema)
values (101);
insert into sali (id_cinema)
values (101);
insert into sali (id_cinema)
values (102);
insert into sali (id_cinema)
values (102);
insert into sali (id_cinema)
values (103);
insert into sali (id_cinema)
values (103);
insert into sali (id_cinema)
values (104);
insert into sali (id_cinema)
values (104);
insert into sali (id_cinema)
values (105);
insert into sali (id_cinema)
values (105);
insert into sali (id_cinema)
values (106);
insert into sali (id_cinema)
values (106);
insert into sali (id_cinema)
values (107);
insert into sali (id_cinema)
values (107);


insert into filme (nume_film, durata, rating, regizor, anul_lansarii)
values ('The Lord of the Rings: The Return of the King', 201, 9.0, 'Peter Jackson', 2003);
insert into filme (nume_film, durata, rating, regizor, anul_lansarii)
values ('Star Wars Episode III: Revenge of the Sith', 140, 7.6, 'George Lucas', 2005);
insert into filme (nume_film, durata, rating, regizor, anul_lansarii)
values ('The Dark Knight', 152, 9.0, 'Christopher Nolan', 2008);
insert into filme (nume_film, durata, rating, regizor, anul_lansarii)
values ('Oppenheimer', 180, 8.3, 'Christopher Nolan', 2023);
insert into filme (nume_film, durata, rating, regizor, anul_lansarii)
values ('Dune Part 2', 166, 8.6, 'Denis Villeneuve', 2024);


insert into difuzari (data, ora, id_sala, id_film)
values ('28-OCT-2018', '17:30', 101, 101);
insert into difuzari (data, ora, id_sala, id_film)
values ('30-NOV-2018', '20:30', 101, 102);
insert into difuzari (data, ora, id_sala, id_film)
values ('17-JUL-2019', '16:30', 103, 101);
insert into difuzari (data, ora, id_sala, id_film)
values ('3-SEP-2019', '18:30', 104, 102);
insert into difuzari (data, ora, id_sala, id_film)
values ('15-DEC-2019', '20:30', 102, 103);
insert into difuzari (data, ora, id_sala, id_film)
values ('27-AUG-2020', '17:45', 105, 101);
insert into difuzari (data, ora, id_sala, id_film)
values ('30-NOV-2020', '20:30', 106, 103);
insert into difuzari (data, ora, id_sala, id_film)
values ('24-JUL-2023', '16:15', 102, 104);
insert into difuzari (data, ora, id_sala, id_film)
values ('1-AUG-2023', '17:30', 107, 104);
insert into difuzari (data, ora, id_sala, id_film)
values ('1-MAR-2024', '19:30', 110, 105);
insert into difuzari (data, ora, id_sala, id_film)
values ('13-MAR-2024', '22:30', 104, 105);


insert into achizitii (email, nr_telefon)
values ('persona@gmail.com', 111111111);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 3, '28-OCT-2018', '17:30', 101, 101, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 4, '28-OCT-2018', '17:30', 101, 101, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 5, '28-OCT-2018', '17:30', 101, 101, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 6, '28-OCT-2018', '17:30', 101, 101, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 7, '28-OCT-2018', '17:30', 101, 101, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 8, '28-OCT-2018', '17:30', 101, 101, 102);

insert into achizitii (email, nr_telefon)
values ('persona@gmail.com', 111111111);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (6, 5, '30-NOV-2018', '20:30', 101, 102, 102);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (6, 6, '30-NOV-2018', '20:30', 101, 102, 102);

insert into achizitii (email, nr_telefon)
values ('persona@gmail.com', 111111111);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (4, 4, '17-JUL-2019', '16:30', 103, 101, 105);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (4, 5, '17-JUL-2019', '16:30', 103, 101, 105);

insert into achizitii (email, nr_telefon)
values ('persone@gmail.com', 555555555);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (6, 5, '3-SEP-2019', '18:30', 104, 102, 105);

insert into achizitii (nr_telefon)
values (777777777);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (7, 4, '27-AUG-2020', '17:45', 105, 101, 108);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (7, 5, '27-AUG-2020', '17:45', 105, 101, 108);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (7, 6, '27-AUG-2020', '17:45', 105, 101, 108);

insert into achizitii (nr_telefon)
values (666666666);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (6, 5, '30-NOV-2020', '20:30', 106, 103, 108);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (6, 6, '30-NOV-2020', '20:30', 106, 103, 108);

insert into achizitii (email)
values ('alexalexandrescu@yahoo.com');
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (3,5, '24-JUL-2023', '16:15', 102, 104, 102);

insert into achizitii (email)
values ('gigelovici.gigel@gmail.com');
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 5, '1-AUG-2023', '17:30', 107, 104, 111);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 6, '1-AUG-2023', '17:30', 107, 104, 111);

insert into achizitii (email)
values ('ion_ionescu@yahoo.com');
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (4, 5, '1-MAR-2024', '19:30', 110, 105, 114);
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (4, 6, '1-MAR-2024', '19:30', 110, 105, 114);

insert into achizitii (email)
values ('david_ov@gmail.com');
insert into bilete (rand, coloana, data, ora, id_sala, id_film, id_angajat)
values (5, 5, '13-MAR-2024', '22:30', 104, 105, 105);


insert into curata (id_angajat, id_sala)
values (103, 101);
insert into curata (id_angajat, id_sala)
values (103, 102);
insert into curata (id_angajat, id_sala)
values (104, 101);
insert into curata (id_angajat, id_sala)
values (104, 102);

insert into curata (id_angajat, id_sala)
values (106, 103);
insert into curata (id_angajat, id_sala)
values (106, 104);
insert into curata (id_angajat, id_sala)
values (107, 103);
insert into curata (id_angajat, id_sala)
values (107, 104);

insert into curata (id_angajat, id_sala)
values (109, 105);
insert into curata (id_angajat, id_sala)
values (110, 106);

insert into curata (id_angajat, id_sala)
values (112, 107);
insert into curata (id_angajat, id_sala)
values (113, 108);

insert into curata (id_angajat, id_sala)
values (115, 109);
insert into curata (id_angajat, id_sala)
values (116, 110);

insert into curata (id_angajat, id_sala)
values (118, 111);
insert into curata (id_angajat, id_sala)
values (119, 112);

insert into curata (id_angajat, id_sala)
values (121, 113);
insert into curata (id_angajat, id_sala)
values (122, 114);

commit;

--12.
/*
1. Sa se obtina informatii complete despre toti angajatii care lucreaza in cinemaul in care au fost efectuate cele mai multe difuzari.
Elemente utilizate: subcereri nesincronizate in clauza FROM (cerinta b), grupari de date, functiile max, count, filtrare la nivel de grupuri cu subcereri nesincronizate (in clauza de HAVING) in care intervin cel putin 3 tabele (in cadrul aceleiasi cereri) (cerinta c)
*/
select *
from angajati
where id_cinema in (select c.id_cinema
                    from cinemauri c join sali s on c.id_cinema = s.id_cinema
                    join difuzari d on s.id_sala = d.id_sala
                    group by c.id_cinema
                    having count(*) = (select max(numar)
                                       from (select cc.id_cinema, count(*) numar
                                             from cinemauri cc join sali s on cc.id_cinema = s.id_cinema
                                             join difuzari d on s.id_sala = d.id_sala
                                             group by cc.id_cinema)));

/*
2. Utilizand clauza WITH, sa se scrie o cerere care afiseaza numele cinemaurilor si valoarea totala a salariilor din cadrul acestora. Se vor considera cienamurile a caror valoare totala a salariilor este mai mare decat media valorilor totale ale salariilor tuturor angajatilor.
Elemente utilizate: bloc de cerere (clauza WITH) (cerinta f), grupari de date, functiile sum, count (cerinta c)
*/
with val_dep as (select nume_cinema, sum(salariu) as total
                 from cinemauri c, angajati a
                 where c.id_cinema = a.id_cinema
                 group by nume_cinema),
val_medie as (select sum(total)/count(*) as medie
              from val_dep)
select *
from val_dep
where total > (select medie
               from val_medie)
order by nume_cinema;

/*
3. Sa se afiseze pentru toti angajatii codul, numele, emailul, slujba, salariul actual si salariul posibil dupa o marire de 20%, respectiv 30% pentru casierii, respectiv ingrijitorii din cinemaurile din afara capitalei, si de 50% pentru sef. Sa se ordoneze rezultatele descrescator dupa salariul posibil.
Elemente utilizate: ordonare, functiile NVL si DECODE in cadrul aceleiasi cereri (cerinta d), functia CASE (cerinta e), functia count  (cerinta c)
*/
select a.id_angajat, a.nume || ' ' ||  a.prenume nume_complet, nvl(email, 'nu are email') email,
decode((select count(*) 
        from casieri c 
        where c.id_angajat = a.id_angajat), 
        1, 'casier', decode((select count(*) 
                             from ingrijitori i 
                             where i.id_angajat = a.id_angajat), 
                             1, 'ingrijitor', 'sef')) slujba, salariu salariu_actual,
(select case when (select count(*) 
                   from casieri c 
                   where c.id_angajat = aa.id_angajat) = 1 then salariu + 20/100 * salariu
             when (select count(*) 
                   from ingrijitori i 
                   where i.id_angajat = aa.id_angajat) = 1 then salariu + 30/100 * salariu  
             else salariu + 50/100 * salariu end salariu_posibil
from angajati aa join cinemauri c using (id_cinema)
where (oras != 'Bucuresti' or id_sef is null) and aa.id_angajat = a.id_angajat
union
select salariu
from angajati aa join cinemauri c using (id_cinema)
where oras = 'Bucuresti' and id_sef is not null and aa.id_angajat = a.id_angajat) salariu_posibil
from angajati a
order by salariu_posibil desc;

/*
4. Sa se genereze adresa de email de la gmail pentru toti angajatii care nu au email si pentru cei care sunt angajati de cel putin 36 de luni si au adresa de email de la yahoo.
Elemente utilizate: functiile months_between, sysdate, concat, lower (cerinta e)
*/
select id_angajat, nume, prenume, round(months_between(sysdate, data_angajarii)) luni, 
email email_vechi, concat(lower(nume) || '.' || lower(prenume) || '.', substr(
decode((select count(*) 
        from casieri c 
        where c.id_angajat = a.id_angajat), 
        1, 'casier', decode((select count(*) 
                             from ingrijitori i 
                             where i.id_angajat = a.id_angajat), 
                             1, 'ingrijitor', 'sef')
), 1, 1) || '@gmail.com') email_nou
from angajati a
where a.email is null 
or round(months_between(sysdate, a.data_angajarii)) >= 60 
and lower(a.email) like '%yahoo.%'
union
select id_angajat, nume, prenume, round(months_between(sysdate, data_angajarii)) luni, 
email email_vechi, email email_nou
from angajati
where email is not null
and (round(months_between(sysdate, data_angajarii)) < 60 
or lower(email) like '%gmail.%');

/*
5. Sa se obtina achizitiile si numarul de bilete cumparate. Se vor lua in considerare doar achizitiile pentru filmele care au ratingul mai mare decat media, facute de clienti care au setat fie email, fie numar de telefon, dar nu ambele.
Elemente utilizate: bloc de cerere (clauza WITH) (cerinta f), subcereri sincronizate in care intervin cel putin 3 tabele (cerinta a), functiile count, avg (cerinta e)
*/
with tabela as
(select id_achizitie, (select count(*)
                       from bilete b join filme f
                       on f.id_film = b.id_film
                       where a.id_achizitie = b.id_achizitie
                       and f.id_film in (select id_film
                                         from filme
                                         where rating > (select avg(rating)
                                                         from filme))) numar_bilete
from achizitii a
where (email is not null and nr_telefon is null)
or (email is null and nr_telefon is not null))
select *
from tabela
where numar_bilete != 0;

--13.
/*
1. Sa se concedieze angajatii din cinemaurile in care nu a fost efectuata nicio difuzare niciodata.
Elemente utilizate: delete
*/
delete
from angajati
where id_cinema not in (select id_cinema
                        from cinemauri c join sali s using(id_cinema)
                        join difuzari d using (id_sala));

/*
2. Sa se mareasca comisionul angajatilor din cinemaul unde au fost efectuate cele mai multe difuzari cu un punct.
Elemente utilizate: update
*/
update angajati
set pct_comision = pct_comision + 0.1
where id_cinema in (select id_cinema
                    from cinemauri join sali using(id_cinema)
                    join difuzari using(id_sala)
                    group by id_cinema
                    having count(*) = (select max(numar)
                                       from (select id_cinema, count(*) numar
                                             from cinemauri join sali using(id_cinema)
                                             join difuzari using(id_sala)
                                             group by id_cinema)));

/*
3. Sa se micsoreze salariul cu 10% sefului din cinemaurile care au efectuat difuzari la care nu au fost vandute bilete.
Elemente utilizate: update
*/
update angajati
set salariu = salariu - 10/100 * salariu
where id_sef = (select id_angajat from angajati where id_sef is null)
and id_cinema in (select id_cinema
                  from sali
                  where id_sala in (select distinct d.id_sala
                                    from difuzari d
                                    where not exists (select * 
                                                      from bilete b 
                                                      where d.id_sala = b.id_sala
                                                      and d.id_film = b.id_film
                                                      and d.data = b.data
                                                      and d.ora = b.ora)));