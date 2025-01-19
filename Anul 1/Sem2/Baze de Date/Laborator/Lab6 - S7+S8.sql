--Laborator 6.pdf
--Sapt 7 + 8
--Subcerei necorelate + corelate

1. Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii care 
au fost angaja?i dup? Gates.
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date --11-07-1998   ---atentie la operator. Ce se intampla daca sunt mai multi Gates?
                    FROM employees
                    WHERE INITCAP(last_name)='Gates')
order by 2; --34 rez
--1". Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii 
--care au fost angaja?i dup? Gates 
--si au salariul mai mare decat el.

SELECT last_name, hire_date, salary
FROM employees
WHERE hire_date > (SELECT hire_date
                    FROM employees
                    WHERE INITCAP(last_name)='Gates')
and salary > ( SELECT salary --2900
                    FROM employees
                    WHERE INITCAP(last_name)='Gates') 
order by 3,2;  --19 rez   

--salariatii cu salariul si data de angajare identice cu cele ale lui Gates
SELECT last_name, hire_date
FROM employees
WHERE (hire_date, salary) IN (SELECT hire_date, salary
                              FROM employees
                              WHERE INITCAP(last_name)='Gates');   
                              
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                    FROM employees
                    WHERE INITCAP(last_name)='King');
                    --ORA-01427: o subinterogare de o singura linie returneaza mai mult dec�t o linie                         
                              
--avem 2 King
17-06-1987
30-01-1996
                              
SELECT last_name, hire_date
FROM employees
WHERE hire_date >any (SELECT hire_date  --mai mare ca minimul
                      FROM employees
                      WHERE INITCAP(last_name)='King')
order by hire_date;   
Whalen	17-09-1987
Kochhar	21-09-1989
Hunold	03-01-1990
Ernst	21-05-1991
De Haan	13-01-1993
Mavris	07-06-1994
Higgins	07-06-1994

SELECT last_name, hire_date
FROM employees
WHERE hire_date >all (SELECT hire_date  --mai mare ca maximul
                    FROM employees
                    WHERE INITCAP(last_name)='King')
order by hire_date; 

Bell	04-02-1996
Hartstein	17-02-1996
Sully	04-03-1996
Abel	11-05-1996
Mallin	14-06-1996
Weiss	18-07-1996
McEwen	01-08-1996
Russell	01-10-1996
Partners	05-01-1997
Davies	29-01-1997

Daca subcererea intoarce o multime de valori, se va folosi in cererea
parinte unul din operatorii IN, NOT IN, ANY, ALL.
WHERE col1 = ANY (SELECT �)  == WHERE col1 IN (SELECT �)
WHERE col1 > ANY (SELECT �) ==  mai mare ca minimul;
WHERE col1 < ANY (SELECT �) == mai mic ca maximul;
WHERE col1 > ALL (SELECT �) == mai mare ca maximul;
WHERE col1 < ALL (SELECT �) == mai mic ca minimul;
WHERE col 1 != ALL (SELECT �)  == WHERE col1 NOT IN (SELECT �)

2. Folosind subcereri, scrie?i o cerere pentru a afi?a numele 
?i salariul pentru to?i colegii (din acela?i departament)
lui Gates. Se va exclude Gates.

SELECT last_name, salary
FROM employees
WHERE department_id In (SELECT department_id -- = 
                        FROM employees
                        WHERE LOWER(last_name)='gates')
AND LOWER(last_name) <> 'gates';  --44 rez

SELECT last_name, salary
FROM employees
WHERE department_id = (SELECT department_id 
                        FROM employees
                        WHERE LOWER(last_name)='gates')
AND LOWER(last_name) <> 'gates';  --44 rez

--King

SELECT last_name, salary, department_id
FROM employees
WHERE department_id In (SELECT department_id  -- nu merege pt =
                        FROM employees
                        WHERE LOWER(last_name)='king')
AND LOWER(last_name) <> 'king';

--incorect
SELECT last_name, salary, department_id
FROM employees
WHERE department_id = (SELECT department_id  -- nu merege pt =
                        FROM employees
                        WHERE LOWER(last_name)='king')
AND LOWER(last_name) <> 'king';
--ORA-01427: o subinterogare de o singura linie returneaza mai mult dec�t o linie

--3.. Folosind subcereri, s? se afi?eze numele ?i salariul angaja?ilor condu?i direct de pre?edintele 
--companiei (acesta este considerat angajatul care nu are manager).
--
--3" Afisati denumirile departamentor in care lucreaza angajati care contin litera 't' in nume.
--(v1:join
--v2:subcerere necorelate) --7 rez

--rezolvare pt 3
select last_name, salary
from employees
where manager_id = (select employee_id
                      from employees
                      where manager_id is null); --14 rez
                      
select last_name, salary
from employees
where manager_id in (select employee_id
                      from employees
                      where manager_id is null); --14 rez                      

--4. Scrie?i o cerere pentru a afi?a numele, codul departamentului ?i salariul angaja?ilor 
--al c?ror cod de departament ?i salariu coincid cu codul departamentului ?i salariul
--unui angajat care c�?tig? comision.

SELECT department_id, salary 
FROM employees 
WHERE commission_pct IS NOT NULL ; -- 35 rez

--atentie; nuuu
SELECT last_name, department_id, salary
FROM employees 
WHERE department_id IN ( SELECT department_id
                        FROM employees 
                        WHERE commission_pct IS NOT NULL )
and salary in (SELECT salary
                FROM employees 
                WHERE commission_pct IS NOT NULL )
                order by salary; --34 REZ   
                
---corect
SELECT last_name, department_id, salary
FROM employees 
WHERE (department_id, salary) IN ( SELECT department_id, salary 
                                    FROM employees 
                                    WHERE commission_pct IS NOT NULL ); --34 REZ    
                                    

                

8. S? se afi?eze numele, departamentul (id), salariul ?i job-ul (titlu job) tuturor angaja?ilor
al c?ror salariu ?i comision coincid cu salariul ?i comisionul unui angajat din Oxford.


Select employee_id, salary, commission_pct, d.department_id
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and initcap(city) = 'Oxford'; --34 rez

Select employee_id, salary, commission_pct, department_id, job_title
from employees e, jobs j
where e.job_id = j.job_id  
and (commission_pct, salary ) in (Select  commission_pct, salary
                                    from employees e, departments d, locations l
                                    where e.department_id = d.department_id
                                    and d.location_id = l.location_id
                                    and initcap(city) = 'Oxford')
order by 2; --35 rez
--178	7000	0.15	
--155	7000	0.15	80
--161	7000	0.25	80

Select employee_id, salary, commission_pct, e.department_id, job_title, city,  d.department_name
from employees e, jobs j, departments d, locations l
where e.job_id = j.job_id(+)   --- afiseaza chiar si angjatii care nu au job 
and e.department_id = d.department_id(+) --- afiseaza si angajatii fara departament
and d.location_id = l.location_id(+)
and (commission_pct, salary ) in (Select  commission_pct, salary
                                    from employees e, departments d, locations l
                                    where e.department_id = d.department_id
                                    and d.location_id = l.location_id
                                    and initcap(city) = 'Oxford')
order by 2; --35 rez



--Ce se intampla daca folosim nvl(commission_pct, 0)? Ne ajuta cu nullurile?
INSERT INTO employees VALUES 
        ( 209
        , 'Test'
        , 'Zlotkey'
        , 'EZLOTKEY_test'
        , '011.44.1344.429018'
        , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 10500
        , null
        , 100
        , 80
        );
commit;       


Select employee_id, salary, commission_pct, d.department_id
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and initcap(city) = 'Oxford'; --35 rez


Select employee_id, salary, commission_pct, e.department_id, job_title, city,  d.department_name
from employees e, jobs j, departments d, locations l
where e.job_id = j.job_id(+)  
and e.department_id = d.department_id(+)
and d.location_id = l.location_id(+)
and (nvl(commission_pct,0), salary ) in (Select  nvl(commission_pct,0), salary
                                    from employees e, departments d, locations l
                                    where e.department_id = d.department_id
                                    and d.location_id = l.location_id
                                    and initcap(city) = 'Oxford')
order by 2; --36 rez - si cel cu comision null si cel cu departament null

----atentie, nu este corect

Select employee_id, salary, commission_pct, department_id, job_title
from employees e, jobs j
where e.job_id = j.job_id
and (commission_pct, salary ) in (Select  commission_pct, salary
                                    from employees e, locations l
--                                    where e.department_id = d.department_id
--                                    and d.location_id = l.location_id
                                    where initcap(city) = 'Oxford')
order by 2; --35 rez (rezolvare incorecta)




--1h                                   
                                    
5. s? se afi?eze codul, numele ?i salariul tuturor angaja?ilor care ca?tig? mai mult 
dec�t salariul mediu pentru job-ul corespunz?tor ?i lucreaz? �ntr-un departament cu cel pu?in unul 
dintre angaja?ii al c?ror nume con?ine litera �t�. Vom considera salariul mediu al unui job ca fiind egal 
cu media aritmetic? a limitelor sale admise 
(specificate �n coloanele min_salary, max_salary din tabelul JOBS).;

SELECT  e.employee_id,e.last_name,e.salary 
FROM employees e 
WHERE e.salary > ( SELECT (j.min_salary+j.max_salary)/2  --angaja?ilor care ca?tig? mai mult dec�t salariul mediu pentru job-ul corespunz?tor
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' ); --24 rez
                          


                          
--fara cerere corelata
SELECT (j.min_salary+j.max_salary)/2 , job_id
FROM jobs j
order by 2;  --pt fiacre job am calculat media salariilor
7000	IT_PROG
6600	FI_ACCOUNT
15000	SA_MAN
9000	SA_REP
4000	SH_CLERK
3500	ST_CLERK

SELECT  e.employee_id,e.last_name,e.salary, e.job_id
FROM employees e 
WHERE (e.salary ,e.job_id) in ( SELECT (j.min_salary+j.max_salary)/2, job_id
                                from jobs j )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' ); --4 rez
                          
SELECT  e.employee_id,e.last_name,e.salary 
FROM employees e 
WHERE e.salary = ( SELECT (j.min_salary+j.max_salary)/2  --angaja?ilor care ca?tig? la fel cu salariul mediu pentru job-ul corespunz?tor
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' ); --24 rez                        

192	Bell	4000	SH_CLERK
141	Rajs	3500	ST_CLERK
158	McEwen	9000	SA_REP
152	Hall	9000	SA_REP
--atentie
--angajatii care au salariul egal cu una dintre media salariala a unui job (j.min_salary+j.max_salary)/2
SELECT  e.employee_id,e.last_name,e.salary, e.job_id
FROM employees e 
WHERE e.salary in ( SELECT (j.min_salary+j.max_salary)/2
                                from jobs j )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' );
103	Hunold	9000	IT_PROG
109	Faviet	9000	FI_ACCOUNT  

SELECT e.employee_id,e.last_name,e.salary 
FROM employees e 
WHERE e.salary > ( SELECT (j.min_salary+j.max_salary)/2 
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
AND e.job_id IN ( SELECT job_id     
                  FROM employees m 
                  WHERE e.department_id=m.department_id 
                  AND LOWER(m.last_name) LIKE '%t%' ); --21 rez

 -- lucreaza pe acelasi job ca si colegii de departament care contin litera t                  
                  
6. Scrieti o cerere pentru a afi?a angaja?ii care c�?tig? mai mult dec�t oricare func?ionar 
(job-ul con?ine ?irul �CLERK�). Sorta?i rezultatele dupa salariu, �n ordine descresc?toare.
Ce rezultat este returnat dac? se �nlocuie?te �ALL� cu �ANY�?
SELECT * 
FROM employees e 
WHERE salary > ALL ( SELECT salary  ---mai mare ca maximul
                    FROM employees 
                    WHERE upper(job_id) LIKE '%CLERK%' )
order by salary;     ---4400 .... 24000               


sELECT salary 
FROM employees 
WHERE upper(job_id) LIKE '%CLERK%'
order by 1; --2100.....4200

SELECT * 
FROM employees e 
WHERE salary > any ( SELECT salary  ---mai mare ca minimul
                    FROM employees 
                    WHERE upper(job_id) LIKE '%CLERK%' )
order by salary; --2200 -24000
--106 rez

7. Scrie?i o cerere pentru a afi?a numele, numele departamentului ?i salariul angaja?ilor 
care  c�?tig? comision, dar al c?ror ?ef direct c�?tig? comision.

select last_name, first_name, department_name, commission_pct, salary
from employees e, departments d
where e.department_id = d.department_id(+)
and e.commission_pct is not null
and e.manager_id in (select employee_id
                     from employees
                     where commission_pct is not null); --30 rez
                     
--subcerere corelata
select last_name, first_name, department_name, commission_pct, salary
from employees e, departments d
where e.department_id = d.department_id(+)
and e.commission_pct is not null
and (select e2.commission_pct
    from employees e2
    where e.manager_id= e2.employee_id ) is not null; --30 rez

--7". Scrie?i o cerere pentru a afi?a numele, numele departamentului ?i salariul angaja?ilor 
--care au salariu mai mare dec�t salariul mediu posibil ( (j.min_salary+j.max_salary)/2  )
--pentru job-ul corespunz?tor , 
--dar al c?ror ?ef direct c�?tig? comision.   

select last_name, first_name, department_name, commission_pct
from employees e, departments d
where e.department_id = d.department_id
and e.salary > ( SELECT (j.min_salary+j.max_salary)/2 
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
and e.manager_id in (select employee_id
                     from employees
                     where commission_pct is not null); --10 rez


--atentie
select last_name, first_name, department_name, commission_pct
from employees e, departments d
where e.department_id = d.department_id
and e.salary > any( SELECT (j.min_salary+j.max_salary)/2 
                    FROM jobs j)
and e.manager_id in (select employee_id
                     from employees
                     where commission_pct is not null); --29 rez




7.. Scrie?i o cerere pentru a afi?a numele salariatului, numele departamentului ?i salariul angaja?ilor 
care c�?tig? comision,dar al c?ror ?ef direct nu c�?tig? comision.(modificata)

select e.last_name, d.department_name, e.salary
from employees e, departments d
where e.department_id = d.department_id(+) -- ca sa tinem cont si de cei care nu au setat departamentul
and e.commission_pct is not null 
and e.manager_id in (select a.employee_id  -- al c?ror ?ef direct nu c�?tig? comision
                      from employees a 
                      where a.commission_pct is null);





                      
--------------------------------  Group by --------------------------------------

select employee_id, salary
from employees
order by 2;

--Care este salariul minim din firma?
select min(salary) --2100
from employees;

--Care este salariatul/salariatii cu salariul minim?

---nu
select employee_id, min(salary) 
from employees;
--ORA-00937: not a single-group group function


--Care este salariatul/salariatii cu salariul minim?
select *
from employees
where salary = (select min(salary) --2100
                from employees);
                --132	TJ	Olson	TJOLSON	650.124.8234	10-04-1999	ST_CLERK	2100		121	50
??? 
de ce nu merge:
select last_name,  min(salary)  ----Care este salariatul cu salariul minim?
from employees;
--ORA-00937: nu exista o functie de grupare de tip grup singular
--Aflam spre finalul lab acesta
--salariul maxim din toata firma


select max(salary)
from employees; --24000

select salary
from employees
order by 1 desc;

--Care este salariatul cu salariul maxim?
select *
from employees
where salary = (select max(salary) --24000
                from employees);
                --100	Steven	King	SKING	515.123.4567	17-JUN-87	AD_PRES	24000			90

--salariul maxim din fiecare departament
select department_id, max(salary)  --- department_id reprezinta o proprietate unica pt fiecare grup/cutiuta
from employees
group by department_id; --12 rez

100	12000
30	11000
null 7000
90	24000
20	13000
70	10000
110	12000
50	8200
80	14000
40	6500
60	9000
10	4400

select salary, employee_id
from employees
where department_id =100
order by 1; --6 rez
6900	113
7700	111
7800	112
8200	110
9000	109
12000	108
---133 2024 semigrupa miercuri

--care este angajatul/angajatii cu acest salariu maxim din fiecare departament?
--atentie, nu aceasta este rezolvarea!!!!!!!!
select department_id, max(salary), employee_id
from employees
group by department_id;
--ORA-00979: nu este o expresie GROUP BY

--incorect
select department_id, max(salary), employee_id
from employees
group by department_id, employee_id ---se divide in 107 grupuri
order by 1,3; --107 rez

--care este angajatul/angajatii cu acest salariu maxim din fiecare departament?
--R: v1 --subcerere necorelata
select employee_id, last_name , department_id, salary
from employees
where (department_id, salary) in (select department_id, max(salary)
                                    from employees
                                    group by department_id)
order by department_id; --11 rez

--daca vreau sa l afisez si pe cel cu dept null
select employee_id, last_name , department_id, salary
from employees
where (department_id, salary) in (select department_id, max(salary)
                                    from employees
                                    group by department_id)
or (salary = (select max(salary)
            from employees
            where department_id is null)
    and department_id is null)
            
order by department_id; --11 rez


--R: v2 -- subcerere corelata
select e.employee_id, e.last_name , e.department_id, e.salary
from employees e  -- linie candidat e.....
where e.salary = (select max(salary)  -- calculam salariul maxim pentru linia candidat
                  from employees b
                  where b.department_id = e.department_id
                  --fara clauza de GROUP BY!!!!!!
                 )
order by department_id; --11 rez

--R: v3 -- subcerere necorelata folosita in clauza FROM
select employee_id, last_name , department_id, salary, sal_max
from employees e, (select department_id dept_id, max(salary) sal_max
                  from employees
                  group by department_id) dept_sal  --tabela
where e.department_id = dept_sal.dept_id   ---join-ul
and e.salary = dept_sal.sal_max    --- conditie de filtrare
order by department_id; --11 rez


--angajatii care au salariul egal cu maximiul din orice departament
select e.employee_id, e.last_name , e.department_id, e.salary
from employees e  -- linie candidat e.....
where e.salary in (select max(salary)  -- calculam salariul maxim pentru fiecare departament
                  from employees 
                  group by department_id); --25 rez
205	Higgins	    110	12000
147	Errazuriz	80	12000
108	Greenberg	100	12000

delete from employees
where employee_id =209;
commit;

--cati angajati se gasesc in total in firma?
select count(*)
from employees; --107 rez

select count(employee_id)
from employees; --107 rez

select count(department_id) -- count(expresie) nu numara si pe cel cu dept_id cu valoarea de null
from employees; --106 rez

--cati salariati sunt angajati in fiecare departament?

select count(*) nr_ang_dept, department_id
from employees
group by department_id; --12 rez
6	100
6	30
1	null  !!!!!!
3	90
2	20
1	70
2	110
45	50
34	80
1	40
5	60
1	10


--atentie la expresia aleasa pt numarare
select count(department_id), department_id --nu ia in considereare valori null
from employees
group by department_id;
6	100
6	30
0	null !!!!!
3	90
2	20

select department_id, employee_id, last_name
from employees
where department_id  is null;
--null 	178	Grant

select count(employee_id), department_id
from employees
group by department_id;

6	100
6	30
1	null  !!!!!
3	90
2	20

select count(employee_id), count(commission_pct)
from employees;
--107	35
-- => 35 de angajati au comisioanele setate

-- Sa se afiseze valoarea medie a comisionului in firma
---pt valoarea medie vom lua in considerare doar comisioanele setate
CORECT:
SELECT AVG(commission_pct) as MEDIE
FROM employees; --0,2228571428571428571428571428571428571429

SELECT SUM(commission_pct)/COUNT(commission_pct) as "MEDIE", sum(commission_pct), COUNT(commission_pct)
FROM employees; --0.2228571428571428571428571428571428571429	7.8	  35

INCORECT ( de ce? ) :
SELECT SUM(commission_pct)/COUNT(*) as "MEDIE GRESITA",  sum(commission_pct), count(*)
FROM employees; --0.072897196261682242990654205607476635514   	7.8  	107


select avg(nvl(commission_pct,0)), SUM(commission_pct)/COUNT(*) 
from employees;

--Sa scriem o cerere pentru a afisa pentru fiecare job titlul,
--codul si valorile comisioanelor nenule ale angajatilor ce-l
--practica. Se vor afisa si comisioanele angajatilor pentru care nu
--se cunoaste jobul, dar care au comision.
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, e.commission_pct
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--ORDER BY j.job_id,e.commission_pct; --35 rez
--
--Sa se afiseze valoarea medie a comisioanelor cunoscute la nivel de job
--= media comisioanelor pt fiecare job(la care lucreaza angajati ce au comisionul setat)
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id; --ORA-00979: nu este o expresie GROUP BY
--
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id, j.job_title;
----Sales Representative	SA_REP	0,21
----Sales Manager	SA_MAN	0,3
--!!!!!!
--Toate coloanele si expresiile de proiectie (din SELECT)
--care NU sunt functii de grup TREBUIE scrise in GROUP BY !!!
--
----job-urile care au media comisioanelor mai mare de 0.25
--!!!!!!!NUUUUUUUUUUUUUUUUUU
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--and avg( e.commission_pct)>0.25  --ORA-00934: functia de grupare nu este permisa aici
--group BY j.job_id, j.job_title;
--
----job-urile care au media comisioanelor mai mare de 0.25
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id, j.job_title
--having avg( e.commission_pct)>0.25;
----Sales Manager	SA_MAN	0,3

11. S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i 
media salariilor tuturor angaja?ilor. 
Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. S? se rotunjeasc? rezultatele.

select max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL,  avg(salary)media, round(avg(salary)) MEDIA_rotunjita,
      floor(avg(salary)) med, round(avg(salary),2)
from employees;
--24000	2100	691400	6461.682242990654205607476635514018691589	6462	6461	6461.68

12. S? se afi?eze minimul, maximul, suma ?i media salariilor pentru fiecare job pe care lucreaza angajati.

select job_id, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees
group by job_id; --19 rez

--atentie
--afisati si titlul job-ului
select e.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, 
        round(avg(salary)) MEDIA,  count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id; --ORA-00979: nu este o expresie GROUP BY


--corect
select e.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title;
--fiecarui job_id ii corespunde un job_title
--19 rez
IT_PROG	Programmer	            9000	4200	28800	5760	5
SA_REP	Sales Representative	11500	6100	250500	8350	30

--atentie
select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title; --j.job_id din select face probleme
--ORA-00979: nu este o expresie GROUP BY

--corect
select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by j.job_id, job_title; --j.job_id 

INSERT INTO jobs VALUES 
        ( 'Test'
        , 'Testadministration Vice President'
        , 15000
        , 30000
        );
        commit;
--dar pt toate job-urile din firma? Avem un job pe care nu lucreaza nimeni
select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(*) NR_ang
from employees e, jobs j
where e.job_id(+) = j.job_id
group by j.job_id, job_title;  --nu


select jj.job_id, jj.job_title, aux.*
from 
    (select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
            count(*) NR_ang
    from employees e, jobs j
    where e.job_id = j.job_id
    group by j.job_id, job_title) aux, jobs jj
where jj.job_id = aux.job_id(+);



13. S? se afi?eze num?rul de angaja?i pentru fiecare job.

select job_id, count(*)
from employees
group by job_id
order by 2; --19 rez

ST_MAN	5
IT_PROG	5
ST_CLERK	20
SH_CLERK	20
SA_REP	30

select job_id, count(employee_id)
from employees
group by job_id
order by 2; --19 rez

select e.job_id, job_title, count(employee_id)
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title
order by 3; --19 rez

ST_CLERK	Stock Clerk         	20
SH_CLERK	Shipping Clerk	        20
SA_REP	    Sales Representative	30

--atentie
select * from employees where department_id is null;
--178	Kimberely	Grant	KGRANT	011.44.1644.429263	24-05-1999	SA_REP
--nu
select job_id, count(department_id)
from employees
group by job_id
order by 2;
ST_MAN	5
IT_PROG	5
ST_CLERK	20
SH_CLERK	20
SA_REP	29  --- deoarece dept_id lui Kimberely	Grant este null



--Care este job-ul pe care lucreaza cei mai multi angajati?
--P1: care este nr-ul maxim de angajati ce lucreaza pe un job?
select max(numar)
from (select job_id, count(*) numar
        from employees
        group by job_id) joburi;
        
--echivalent cu o superagregare:
select job_id, max(count(*)) numar_maxim  --- atentie!!! La super-agregari nu mai pot afisa alta coloana
from employees
group by job_id;

--corecta:
select  max(count(*)) numar_maxim  --- atentie!!! 
from employees
group by job_id;  --- R: 30


--P2 : Care este job-ul (titlu) pe care lucreaza cei mai multi angajati?

select e.job_id, job_title, count(*) numar
from employees e , jobs j
where e.job_id= j. job_id
group by e.job_id, job_title
having count(*) = (select  max(count(*)) numar_maxim
                    from employees
                    group by job_id);

--salariatii care lucreaza pe job-ul la care sunt angajati cei mai putini salariati
select *
from employees
where job_id in
                (select e.job_id
                from employees e 
                group by e.job_id
                having count(*) = (select  min(count(*)) numar_maxim    ---niciodata nu avem where count(...) = (...)
                                    from employees
                                    group by job_id)
                );
--DOAR pt functiile de agregare folosim clauza de HAVING

14. Sa se determine numarul de angaja?i care sunt sefi(manageri directi). Eticheta?i coloana �Nr. manageri�.
Observa?ie: Este necesar cuv�ntul cheie DISTINCT. Ce obtinem daca �l omitem?

--nu este rezolvarea
select employee_id, manager_id
from employees;

--lista a managerilor din firma
select distinct manager_id
from employees
where manager_id is not null
order by 1; --18 rez


--informatii complete despre manageri
select *
from employees
where employee_id in (select manager_id from employees); --18 rez



select distinct manager_id
from employees; --19 (deoarece nu l-am exclus pe cel cu null(manager_id pt Steven King = null))

--atentie: 106 angajati au managerul direct setat
select count( manager_id) --nu
from employees; --18 sefi

--R:
select count(distinct manager_id)  --nu ia in considerrare valorile de null
from employees; --18 sefi

--R:
select count(distinct manager_id)
from employees
where manager_id is not null; --nu este obligatoriu nevoie de cluaza de where

15. S? se afi?eze diferen?a dintre cel mai mare ?i cel mai mic salariu  pe
departament. Afisati si id-ul departamentului. Eticheta?i coloana �Diferenta�.

select max(salary) - min(salary) Diferenta, department_id, count(*) nr_ang_din_dept
from employees
group by department_id;

16. Scrieti o cerere pentru a se afisa numele departamentului, locatia (city), 
numarul de angajati si salariul mediu pentru angajatii din acel departament. 
Coloanele vor fi etichetate corespunzator.
Observa?ie: �n clauza GROUP BY se trec obligatoriu toate coloanele prezente 
�n clauza SELECT,care nu sunt argument al functiilor grup 
(a se vedea ultima observatie de la punctul I).

--atentie
select department_name, city, count(employee_id), round(avg(salary))
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id= l.location_id
group by d.department_id; 
--ORA-00979: nu este o expresie GROUP BY

--R:
select department_name, city, count(employee_id) nr_ang, round(avg(salary))
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id= l.location_id
group by e.department_id,  department_name, city
having count(employee_id)>4;
--fiecare departament are un singur nume si o singura locatie in care se gaseste !!!!!!!!!!!!!!!

--R:
select department_name, city, count(employee_id), round(avg(salary))
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id= l.location_id
group by department_name, city; ---11 rez
---fiecare dept are un nume unic => pot face grupare doar dupa department_name

--atenite
--nr de ang si sal mediu pt fiecare departament
select department_id dept_id, count(*) nr_ang, round(avg(salary)) sal_mediu
from employees
group by department_id; --12 rez

--Rez V2 subcerere necorelata in clauza de FROM
select department_name, city, nr_ang, sal_mediu, aux.dept_id
from locations l, departments d, 
    (select department_id dept_id, count(*) nr_ang, round(avg(salary)) sal_mediu --- trebuie sa pune alias pt coloanele cu fct de agregare
    from employees
    group by department_id) aux
where l.location_id = d.location_id
and aux.dept_id = d.department_id;
--11 rez


16-2. Scrieti o cerere pentru a se afisa numele departamentului, locatia (city),tara (country_name) 
numarul de angajati si salariul mediu pentru angajatii din acel departament. 
Coloanele vor fi etichetate corespunzator.

select department_name, city, country_name, count(employee_id), round(avg(salary))
from employees e, departments d, locations l, countries c
where d.department_id = e.department_id
and d.location_id= l.location_id
and l.country_id = c.country_id
group by e.department_id,  department_name, city, country_name; --11 rez

select department_name, city, nr_ang, sal_mediu, aux.dept_id
from countries c, locations l, departments d, 
    (select department_id dept_id, count(*) nr_ang, round(avg(salary)) sal_mediu --- trebuie sa pune alias pt coloanele cu fct de agregare
    from employees
    group by department_id) aux
where  l.country_id = c.country_id
and l.location_id = d.location_id
and aux.dept_id = d.department_id; --11 rez



---------------------------------------133 miercuri
17. S? se afi?eze codul ?i numele angaja?ilor care c�stig? mai mult dec�t 
salariul mediu din firm?. Se va sorta rezultatul �n ordine descresc?toare a salariilor.

--care este salariul mediu din firma?
select avg(salary)
from employees;
--6461,682242990654205607476635514018691589

---R1:
select employee_id, last_name, salary
from employees
where salary> (select avg(salary)
                from employees)
order by salary desc;        --51 rez    
--123	Vollman	6500

--R2:
select employee_id, first_name || ' ' || last_name, salary,aux.sal
from employees,(select avg(salary) sal
                from employees) aux
where salary>aux.sal   ---- nu pot pune aux.avg(salary)
order by 3 desc; --51 rez


select employee_id, first_name || ' ' || last_name, salary,aux.sal
from employees,(select avg(salary) 
                from employees) aux
where salary>aux.avg(salary) ---ORA-00904: "AUX"."AVG": invalid identifier
order by 3 desc;


--17". S? se afi?eze codul ?i numele angaja?ilor care c�stig? mai mult dec�t 
--salariul mediu din departamentul in care lucreaza.
--Se va sorta rezultatul �n ordine descresc?toare a salariilor.

select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary> (select avg(a.salary) --salariul mediu din departamentul in care lucreaza.
                from employees a
                where a.department_id = e.department_id) --fara group by!!!
order by  e.salary desc;  --38 rez

--rezolvare identica cu cea de sus
--fara alias pt a doua tabela
select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary> (select avg(salary) --salariul mediu din departamentul in care lucreaza.
                from employees 
                where department_id = e.department_id)
order by  e.salary desc;  --38 rez


---V2: 
select employee_id, first_name || ' ' || last_name, salary,aux.sal_med, e.department_id
from employees e,(select department_id, avg(salary) sal_med
                  from employees
                  group by department_id) aux
where e.department_id=aux.department_id 
and salary > aux.sal_med
order by 3 desc;--38 rez

--nu
select distinct employee_id, first_name || ' ' || last_name, salary
from employees, (select avg(salary) salariu
                  from employees
                  group by department_id) sal
where salary > sal.salariu  ---salariu mai mare ca un salariu mediu din orice departament
order by salary desc; --70 rez

--nu
select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary >any (select avg(salary)  --subcererea returneaza mai multe rezultate
                      from employees 
                      group by department_id)
order by  e.salary desc;  --70 rez


--141	Rajs	3500 50
select avg(a.salary)
from employees a
where a.department_id = 50; --3475,555555555555555555555555555555555556


select employee_id, salary
from employees a
where a.department_id = 50
order by 2;

--atentie
--nu
select employee_id, last_name
from employees e1
where salary>(select avg(salary) 
              from employees e2 
              where e1.department_id=e2.department_id  --);
              group by e2.department_id);---in plus !!!!!!

--nu
select last_name, employee_id
from employees
where salary > ( select avg(e.salary)  --6456,603773584905660377358490566037735849
                from employees e, departments d  --media salariilor pt angajatii care lucreaza in departamente
                where e.department_id = d.department_id)
order by salary desc;              

18. Pentru fiecare ?ef, s? se afi?eze codul sau  si salariul celui mai pu?in platit 
subordonat al s?u. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile �n care salariul minim este mai mic de 4000$. 
Sorta?i rezultatul �n ordine descresc?toare a salariilor.

select e.manager_id, min(e.salary)
from employees e
where e.manager_id is not null --Se vor exclude cei pentru care codul managerului nu este cunoscut
group by e.manager_id     -- Pentru fiecare sef
having min(salary) >4000 --se vor exclude grupurile �n care salariul minim este mai mic de 4000$.
order by 2; --12 rez

--nuuuu
select e.manager_id, min(e.salary)
from employees e
where e.manager_id is not null 
and min(salary) >4000   --ORA-00934: functia de grupare nu este permisa aici
group by e.manager_id     
order by 2; 

18. Pentru fiecare ?ef, s? se afi?eze codul s?u ?i salariul celui mai pu?in platit 
subordonat al s?u. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile �n care salariul minim este mai mic de 4000$. 
Sorta?i rezultatul �n ordine descresc?toare a salariilor.

--- codul managerului si salariul minim al subordonatilor

select e.manager_id, min(e.salary)  
from employees e
where e.manager_id is not null 
group by e.manager_id     
having min(salary) >4000 ; -- 12 rez

--18" la rezovarea de mai sus, afisati si care este salariatul care are acel 
--salariu minim

--v1 subcerere necorelata in clauza de WHERE
select a.manager_id Managerul, a.employee_id Angajatul, a.last_name, a.salary Salariul_angajatului
from employees a
where (a.manager_id, a.salary) in (select e.manager_id, min(e.salary)
                                  from employees e
                                  where e.manager_id is not null 
                                  group by e.manager_id     
                                  having min(salary) >4000 )
order by 1; -- 12 rez

--v2  -- subcerere necorelata in clauza de FROM
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului, sal_min
from employees a, (select e.manager_id, min(e.salary) sal_min
                  from employees e
                  where e.manager_id is not null 
                  group by e.manager_id     
                  having min(salary) >4000 ) aux
where a.manager_id = aux.manager_id   ---conditia de join
and a.salary = aux.sal_min; --12 rez  ---conditia de filtrare

 --v3 subcerere corelata  in clauza de WHERE                               
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului
from employees a
where  a.salary = (select  min(e.salary)
                  from employees e
                  --where e.manager_id is not null  --este in plus(datorita join-ului)
                  where  e.manager_id  = a.manager_id 
                  --nu este nevoie de group by!!!!
                  having min(salary) >4000 ); --12 rez  
                  
select  min(e.salary)
from employees e
--where e.manager_id is not null  --este in plus(datorita join-ului)
where  e.manager_id  = 121  --min(e.salary) = 2100
--nu folosim group by!!!!
having min(salary) >4000 ; --null
                  
select  min(e.salary)
from employees e
--where e.manager_id is not null  --este in plus(datorita join-ului)
where  e.manager_id  = 102  --min(e.salary) = 9000
--nu folosim group by!!!!
having min(salary) >4000 ; --null

 --nu, nu este buna gruparea aleasa
 select e.manager_id, min(e.salary),e.employee_id
from employees e
where e.manager_id is not null
group by e.manager_id, e.employee_id 
having min(salary) >4000;

--nu
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului
from employees a
where a.salary in (select  min(e.salary)
                                  from employees e
                                  where e.manager_id is not null 
                                  group by e.manager_id     
                                  having min(salary) >4000 ); -- 18 rez
                  
-----------------------------------------------------------------------------------------------------final s8                  
--Ex:  Sa se afiseze codul si numele angajatilor care c�stiga  
--cel mai mult pe job-ul pe care lucreaza.
--Se va sorta rezultatul �n ordine descrescatoare a salariilor.                 

--R:V1 - subcerere corelata

SELECT e.employee_id cod,
  e.first_name
  || ' '
  || e.last_name nume
FROM employees e
WHERE salary =
  ( SELECT MAX(salary) FROM employees WHERE job_id = e.job_id
  ); --20 rez

--R:V2 - Select in FROM
SELECT
   e.employee_id,e.last_name  
FROM employees e,
   (   SELECT  e.job_id cod ,   MAX(e.salary) salariu
        FROM  employees e
        GROUP BY e.job_id
    ) a
WHERE a.salariu=e.salary and a.cod=e.job_id 
order by 1;  --20 rez

--R: V3 - subcerere necorelata
SELECT
   e.employee_id,e.last_name  
FROM employees e
where (e.job_id, e.salary) in
                             (   SELECT  e.job_id cod ,   MAX(e.salary) sala
                                  FROM  employees e
                                  GROUP BY e.job_id
                              ) 
order by 1;  --20 rez


--Ex: Sa se afiseze angajatii care au salariul minim din fiecare locatie care se termina in e.   

select employee_id, salary, d.department_id, city
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and (city, salary) in ( select city, min(salary)  -- 2 orase
                          from employees e1, departments d1, locations l1
                          where e1.department_id = d1.department_id
                          and d1.location_id = l1.location_id
                          and lower(l1.city) like '%e'
                          group by city)
order by 3,2; --2 rez


select employee_id, salary, d.department_id, city
from employees e, departments d, locations loc
where e.department_id = d.department_id
and d.location_id = loc.location_id
and lower(loc.city) like '%e'
and salary = ( select  min(salary)  -- 2 orase
              from employees e1, departments d1
              where e1.department_id = d1.department_id
              and d1.location_id = loc.location_id
              )
order by 3,2; --2 rez

119	2500	30	Seattle
107	4200	60	Southlake


--Ex: Sa se afiseze angajatii care au salariul minim din fiecare departament.    

--salariul maxim din fiecare departament
select department_id, min(salary)
from employees
group by department_id; --12 rez


--R:V1
select employee_id, department_id
from employees e
where e.salary = (select min(e1.salary)
                  from employees e1
                  where e1.department_id = e.department_id)
order by 2; --12 rez

select * from employees where department_id = 90;

--R: V2
select e.employee_id, e.salary
from employees e, (select department_id, min(salary) sal 
                    from employees 
                    group by department_id) maxime
where e.department_id=maxime.department_id 
and e.salary=maxime.sal; --12 rez


--R:V3
select employee_id, salary
from employees
where (department_id, salary) in( select department_id, min(salary)
                                  from employees
                                  group by department_id); --12 rez


--nu 
select employee_id, salary
from employees
where salary in( select  min(salary)
                from employees
                group by department_id); --26 rez
                



afisati salariul mediu al angajatilor daca este mai mare de 10000

select avg(salary)
from employees
where avg(salary) > 10000;
--ORA-00934: group function is not allowed here

select avg(salary)
from employees
having avg(salary) > 10000; --null



select employee_id
from employees
having salary >10000; ----

select department_id
from employees
group by department_id
having department_id >50;  ---nu (6 rez)


select department_id
from employees
where department_id >50
group by department_id; ---daaa (6 rez)




--depart cu mai mult de 10 ang

select department_id, count(*)
from employees
group by department_id
having count(*) >10; -- 2 rez


--afisati angajatii care au salariul egal cu un salariu maxim din orice departament


--Cati angajati lucreaza in fiecare locatie? Afisati orasul si numarul de angajati din fiecare oras.
--Pentru fiecare locatie, care este salariul maxim al angajatilor care lucreaza in acele locatii.
--Pentru fiecare locatie, care este numele angajatilor care au salariul maxim si lucreaza in acele locatii.



                                  

19. Pentru departamentele in care salariul maxim dep??e?te 7000$, s? se ob?in? codul, numele acestor 
departamente ?i salariul maxim pe departament.

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,MAX(E.SALARY)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
HAVING MAX(E.SALARY)>7000; --9 rez






