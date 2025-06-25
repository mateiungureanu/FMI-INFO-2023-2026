 select employee_id,first_name, last_name, manager_id from employees;
--seful firmei =angajatii care nu au manager

select first_name, last_name
from employees
where manager_id is null; --Steven	King

--nu

select first_name, last_name
from employees
where manager_id = null; --nu returneaza nimic ( null nu este egal cu null in clauza de where)


--angajatii care nu au departament
select first_name
from employees
where department_id is null; --Kimberely


select first_name
from employees
where departme
nt_id = null; --nu este corect

--departamentele care nu au manager
select department_id, department_name
from departments
where manager_id is null; --16 rez

-------Functii de conversie
select to_date('26/02/2022', 'DD/MM/YYYY')
from dual; --26-FEB-22

select to_date('26/02/2022', 'DD/MON/YYYY')
from dual; --nu  --ORA-01843: not a valid month

select to_char(to_date('26/MAR/22', 'DD/MON/YY'), 'YYYY')
from dual; --2022

select to_char(to_date('26/MAR/22', 'DD/MON/YY'), 'MM')
from dual; --03

select substr('primavara', 4)
from dual; --mavara

select substr('primavara', 4, 1)
from dual; --m

select substr('primavara', 4, 2)
from dual; --ma

select substr('primavara', 1, 4)
from dual; --prim

select substr('primavara',-4)
from dual; --vara

select substr('primavara',-1)
from dual; --a

select substr('primavara',length('primavara'))
from dual; --a

select substr('primavara',length('primavara'),1)
from dual; --a

select substr('primavara',length('primavara')-3)
from dual; --vara
select substr('primavara',length('primavara')-3,4)
from dual; --vara



select rtrim('XXXprimavaraXXXX', 'X')
from dual; -- XXXprimavara

select rtrim('XXXprimavarXaXXXX', 'X')
from dual; -- XXXprimavarXa

select ltrim('XXXprimavarXaXXXX', 'X')
from dual; -- primavarXaXXXX

select trim( both 'X'  from 'XXXprimavarXaXXXX')
from dual; -- primavarXa

select trim('XXXprimavarXaXXXX', 'X')  ---nu 
from dual;

select rtrim('XXXprimavarXaXXXaXa', 'Xa')
from dual; -- XXXprimavar

select rtrim('XXXprimavarXaXbXXaXa', 'Xa')
from dual; -- XXXprimavarXaXb


select length('XXXprimavarXaXXXX       ')
from dual; --24
select length(rtrim('XXXprimavarXaXXXX       '))
from dual; -- XXXprimavarXaXXXX  --17

select (rtrim('XXXprimavarXaXXXX       '))
from dual; --XXXprimavarXaXXXX

select 'XXXprimavarXaXXXX       '
from dual;


select replace('XXXprimXavarXaXXXX', 'X')
from dual; -- primavara

select replace('XXXprimavarXaXXXX', 'X', '*')
from dual; -- ***primavar*a****

select replace('1212131', '12')
from dual; --131

select replace('1212131', '12', 'ab')
from dual; --abab131
select replace('1212131', '12', 'abc')
from dual; --abcabc131

select translate('1212131', '12', 'ab')
from dual; --ababa3a

select translate('1212131', '123', 'ab')
from dual; --ababaa

select translate('1212131', '123','abc')
from dual; --ababaca

select translate('1212131', '123','abcd')
from dual; --ababaca

select translate('121213 1 ', '123 ','abcd')
from dual; --ababacdad

select translate('1212131', '112', 'ab')
from dual; --aaa3a

select translate('1212131aaa', '1a', 'ab')
from dual; --a2a2a3abbb

select translate('141234123444444123', '1234','abcd')
from dual; --adabcdabcddddddabc

select replace('141234123444444123', '1234','abcd')
from dual; --14abcdabcd44444123

select replace('141234123444444123', '1234',10101)  --10101   '10101'
from dual; --14101011010144444123 --conversie implicita

select translate('141234123444444123', '1234',99998)
from dual; -- 999999999999999999 -ignora 8


select translate('141234123444444123', '1234',9)
from dual; -- 9999
select translate('141234123444444123', '123',9)
from dual; -- 949494444449
select replace('141234123444444123', '1234')
from dual; -- 1444444123

select length(rtrim('Ionel Popescu                ', ' '))
from dual; --13

select length('Ionel Popescu                      ')
from dual; --35

III. [Exerci?ii]
[Func?ii pe ?iruri de caractere]
1. Scrie?i o cerere care are urm?torul rezultat pentru fiecare angajat: 
<prenume angajat> <nume angajat> castiga <salariu> lunar 
dar doreste <salariu de 3 ori mai mare>.
Etichetati coloana  Salariu ideal . Pentru concatenare, utiliza?i at t 
func?ia CONCAT c t ?i operatorul  || .

SELECT CONCAT(CONCAt(first_name, ' '), last_name) ||' castiga '|| salary
 || ' lunar dar doreste ' || salary*3 ||'.' "Salariu ideal"
FROM employees;

2. Scrie?i o cerere prin care s? se afi?eze prenumele salariatului cu prima 
litera majuscul? ?i toate celelalte litere minuscule, numele acestuia cu
majuscule ?i lungimea numelui, 
pentru angaja?ii al c?ror nume  ncepe cu J sau M sau care au a treia liter? din nume A. 
Rezultatul va fi ordonat descresc?tor dup? lungimea numelui. Se vor eticheta 
coloanele corespunz?tor. Se cer 2 solu?ii (cu operatorul LIKE ?i func?ia SUBSTR).

select initcap(first_name), upper(last_name), length(last_name)
from employees
where upper(last_name) like 'J%' or upper(last_name) like 'M%' 
or upper(last_name) like '__A%'
order by length(last_name) desc; --15 rez

select initcap(first_name), upper(last_name), length(last_name)
from employees
where upper(last_name) like 'J%' or upper(last_name) like 'M%' 
or upper(last_name) like '__A%'
order by 3 desc; --15 rez

select initcap(first_name), upper(last_name), length(last_name) 
from employees 
where substr(upper(last_name),1,1)='J' or substr(upper(last_name),1,1)='M' 
or substr(upper(last_name),3,1)='A' 
order by length(last_name) desc; --15 rez

select initcap(first_name), upper(last_name), length(last_name) 
from employees 
where substr(upper(last_name),1,1) IN ('J','M') or upper(substr(last_name,3,1))='A' 
order by length(last_name) desc; --15 rez


3. S? se afi?eze, pentru angaja?ii cu prenumele  Steven , codul ?i numele acestora, 
precum ?i codul departamentului  n care lucreaz?. C?utarea trebuie s? nu fie 
casesensitive, iar eventualele blank-uri care preced sau urmeaz? numelui trebuie ignorate.

select employee_id, last_name, first_name, department_id
from employees 
where trim(both ' ' from lower(first_name)) = 'steven';

100	King	Steven	90
128	Markle	Steven	50

4. S? se afi?eze pentru to?i angaja?ii al c?ror nume se termin? cu litera 'e', codul, numele, 
lungimea numelui ?i pozi?ia din nume  n care apare prima data litera 'a'.
Utiliza?i aliasuri corespunz?toare pentru coloane. 



select employee_id, last_name, first_name, length(last_name) lungime, instr(lower(last_name),'a')
from employees
where lower(last_name) like '%e'
order by lungime; --5 rez

select employee_id, last_name, first_name, length(last_name),  instr(lower(last_name),'a')
from employees
where substr(lower(last_name),-1) = 'e'; --5 rez

select employee_id, last_name, first_name, length(last_name),  instr(lower(last_name),'a')
from employees
where substr(lower(last_name),length(last_name)) = 'e'; --5 rez

select employee_id, last_name, first_name, length(last_name),  instr(lower(last_name),'a')
from employees
where substr(lower(last_name),length(last_name),1) = 'e'; --5 rez


--Functii pt date calendaristice
alter session set nls_language=American;

select next_day(sysdate, 'Monday')
from dual;  --11-MAR-24

select next_day('12/MAR/2024', 'Monday') --conversie implicita de la string la date
from dual;  --11-MAR-24


select next_day('08/MAR/2022', 'Monday')
from dual;  --14-MAR-22

select next_day('07/MAR/2022', 'Monday')
from dual;  --14-MAR-22

select Last_day('01-FEB-2024') --conversie implicita de la string la date
from dual; --29-FEB-24

select Last_day(sysdate)
from dual; --31-MAR-24

select Last_day('11-FEB-2024')
from dual; --29-FEB-24

select TO_CHAR(SYSDATE, 'dd/mm/yy HH24:MI') 
from dual; --28/02/23 19:04

select TRUNC(SYSDATE)
from dual; --02-MAR-22

select TO_CHAR(TRUNC(SYSDATE), 'dd/mm/yy HH24:MI') 
from dual; --02/03/22 00:00


select sysdate +2
from dual; --08-MAR-24

select TO_CHAR((SYSDATE+2), 'dd/mm/yy HH24:MI') 
from dual; --09/03/24 09:43

select TO_CHAR((SYSDATE+2.5), 'dd/mm/yy HH24:MI') 
from dual; --09/03/24 21:43

select sysdate +60
from dual; --05-MAY-24


select add_months(sysdate, 2)
from dual; --06-MAY-24


[Func?ii aritmetice]
5. S? se afi?eze detalii despre salaria?ii care au lucrat un num?r  ntreg de s?pt?m ni 
p n? la data curent?. 
Obs: Solu?ia necesit? rotunjirea diferen?ei celor dou? date calendaristice. De ce este 
necesar acest lucru?

select  employee_id, sysdate-hire_date
from employees
order by 1;
--28.02.2023 ora 19
100	13040.7968287037037037037037037037037037
101	12213.7968287037037037037037037037037037
102	11003.7968287037037037037037037037037037

--01.03.2023 ora 11
100	13041.4641435185185185185185185185185185
101	12214.4641435185185185185185185185185185
102	11004.4641435185185185185185185185185185

--01.03.2023 ora 12:43
100	13041.5278819444444444444444444444444444
101	12214.5278819444444444444444444444444444
102	11004.5278819444444444444444444444444444
--
100	13042,3899537037037037037037037037037037
101	12215,3899537037037037037037037037037037
102	11005,3899537037037037037037037037037037

100	13042,4652083333333333333333333333333333
101	12215,4652083333333333333333333333333333
102	11005,4652083333333333333333333333333333

select employee_id, trunc(sysdate) - trunc(hire_date)
from employees
order by 1;
-2022
100	12677
101	11850
102	10640

--2023
100	13041
101	12214
102	11004

--2024
100	13412
101	12585
102	11375
103	12481

select employee_id, trunc(sysdate) - trunc(hire_date) nr_zile
from employees
where mod(trunc(sysdate) - trunc(hire_date),7) =0; --21 rez --miercuri 02.03.2022
--17 rez  - joi 03.03.2022



select employee_id, trunc(sysdate) - trunc(hire_date) nr_zile
from employees
where mod(nr_zile,7) =0; 

-- nu cunoaste cn este acest alias pt ca nu a ajuns la caluza de select


--6. S? se afi?eze codul salariatului, numele, salariul, salariul m?rit cu 15%, exprimat cu 
--dou? zecimale ?i num?rul de sute al salariului nou rotunjit la 2 zecimale. Eticheta?i 
--ultimele dou? coloane  Salariu nou , respectiv  Numar sute . Se vor lua  n considerare 
--salaria?ii al c?ror salariu nu este divizibil cu 1000.
--
--\
--Select employee_id, last_name, salary, salary*1.15 --, ceil(salary*1.15)
--from employees
--where mod(salary,1000) !=0;
--
--7. S? se listeze numele ?i data angaj?rii salaria?ilor care c ?tig? comision. S? se 
--eticheteze coloanele  Nume angajat ,  Data angajarii . Utiliza?i func?ia RPAD pentru a 
--determina ca data angaj?rii s? aib? lungimea de 20 de caractere.

--functii diverse

select nvl(null, 1)
from dual; --1

select nvl(20, 1) --20 =/ null
from dual; -- 20


select nvl('a', 1)  --conversi implicita a lui 1 la '1'
from dual; --a

select nvl('', 1)  --conversi implicita a lui 1 la '1'
from dual; --1

select nvl(null, 1) 
from dual; --1 (number)

select nvl(1, 'ab')
from dual; --ORA-01722: invalid number

select nvl(to_char(1), 'ab')
from dual; --1

select nvl(1, '2')  --'2' poate fi covertit la number 2
from dual;--1 

select nvl(1, '2a')
from dual;--ORA-01722: invalid number


select nvl(1.50, 10.50)
from dual; --1,5  --> tip number

select nvl('1.50', '10.50')
from dual; --1.50   --> string

select nvl(1, 'a') --> nvl(number, string)
from dual; -- vrea sa converteasca 'a' la number -->eroare

select  nvl(to_char(1.50000), 'a') --> nvl( string, string); 1.50  este number
from dual; -- 1,5

--NVL2(exp1, exp2_daca_nu_este_null_exp1, exp3_Altfel)

select NVL2( 1, 20, 30) -- 1/= null
from dual; --20

select nvl(1,30) -- 1/= null
from dual;  --1

select NVL2( null, 20, 30)
from dual; --30

--obs:
select nvl(20, 1) --20 =/ null
from dual; -- 20

select nvl2(20,20, 1) --20 =/ null
from dual; --20



select employee_id, first_name, last_name,
    nvl(manager_id,  0), manager_id
from employees
order by 4;

NVL2(exp1, exp2_daca_nu_este_null_exp1, exp3_Altfel)

