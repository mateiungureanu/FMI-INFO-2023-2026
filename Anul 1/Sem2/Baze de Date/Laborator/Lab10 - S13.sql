Pe baza tabelului EMP_***, s? se creeze o vizualizare VIZ_EMP30_***, care con?ine
codul, numele, email-ul ?i salariul angaja?ilor din departamentul 30. 
S? se analizeze structura ?i con?inutul vizualiz?rii. Ce se observ? referitor la
constrângeri? Ce se ob?ine de fapt la interogarea con?inutului vizualiz?rii? 
Insera?i o linie prin intermediul acestei vizualiz?ri; comenta?i.

SELECT * FROM EMP_***;

CREATE OR REPLACE  VIEW VIZ_EMP30_***
AS (SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY
    FROM EMP_***
    WHERE DEPARTMENT_ID =30);
    
SELECT * FROM  VIZ_EMP30_***
ORDER BY SALARY;

SELECT * FROM USER_UPDATABLE_COLUMNS
WHERE UPPER(TABLE_NAME) = 'VIZ_EMP30_***' ;


DESC EMP_***;

EMPLOYEE_ID    NOT NULL NUMBER(6)    
FIRST_NAME              VARCHAR2(20) 
LAST_NAME      NOT NULL VARCHAR2(25) 
EMAIL          NOT NULL VARCHAR2(25) 
PHONE_NUMBER            VARCHAR2(20) 
HIRE_DATE      NOT NULL DATE         
JOB_ID         NOT NULL VARCHAR2(10) 
SALARY                  NUMBER(8,2)  
COMMISSION_PCT          NUMBER(2,2)  
MANAGER_ID              NUMBER(6)    
DEPARTMENT_ID           NUMBER(4)    

UPDATE viz_emp30_***
SET SALARY=SALARY-15
WHERE employee_id=114;

SELECT * FROM EMP_*** WHERE EMPLOYEE_ID =114;

INSERT INTO  VIZ_EMP30_*** 
VALUES (300,	'Raphaely', 'Den' ,'DRAPHEAL',	10955);
Error report -
ORA-01400: nu poate fi inserat NULL în ("GRUPA34"."EMP_***"."HIRE_DATE")


UPDATE viz_emp30_***
SET hire_date=hire_date-15
WHERE employee_id=114;

CREATE OR REPLACE  VIEW VIZ_EMP30_***
AS (SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY, HIRE_DATE, JOB_ID
    FROM EMP_***
    WHERE DEPARTMENT_ID =30);
    
SELECT * FROM  VIZ_EMP30_***
ORDER BY SALARY;
--
--delete from EMP_*** where employee_id in (300,301,302);

INSERT INTO  VIZ_EMP30_*** 
VALUES (300,	'Raphaely', 'Den' ,'DRAPHEAL',	10955	,'07-DEC-94',	'PU_MAN');

SELECT * FROM EMP_*** WHERE EMPLOYEE_ID =300;

CREATE OR REPLACE  VIEW VIZ_EMP50_***
AS (SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY*12 SAL_ANUAL, HIRE_DATE, JOB_ID
    FROM EMP_***
    WHERE DEPARTMENT_ID =50);

    
SELECT * FROM  VIZ_EMP50_***
ORDER BY 5;

SELECT * FROM USER_UPDATABLE_COLUMNS
WHERE UPPER(TABLE_NAME) = 'VIZ_EMP50_***' ;


INSERT INTO  VIZ_EMP50_*** 
VALUES (301,	'Raphaely', 'Den' ,'DRAPHEAL'	,12000, '07-DEC-94',	'PU_MAN');
-- SQL Error: ORA-01733: virtual column not allowed here
--01733. 00000 -  "virtual column not allowed here"
--*Cause:    
--*Action:

INSERT INTO  VIZ_EMP50_*** ( EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES (301,	'Raphaely', 'Den' ,'DRAPHEAL'	,'07-DEC-94',	'PU_MAN');
--1 row inserted.

SELECT * FROM EMP_*** WHERE EMPLOYEE_ID =301;



SELECT * FROM DEPT_***;

CREATE OR REPLACE  VIEW VIZ_EMP30_DEPT_***
AS (SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY,
            HIRE_DATE, JOB_ID, D.DEPARTMENT_ID, DEPARTMENT_NAME
    FROM EMP_*** E, DEPT_*** D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID 
    AND E.DEPARTMENT_ID =30);

SELECT * FROM  VIZ_EMP30_DEPT_***
ORDER BY SALARY;

SELECT * FROM USER_UPDATABLE_COLUMNS
WHERE UPPER(TABLE_NAME) = 'VIZ_EMP30_DEPT_***' ;

insert into VIZ_EMP30_DEPT_***
values (302,	'Colmenares',	'Karen',	'KCOLMENA',	2500,	'10-08-1999',	'PU_CLERK',	30	,'Purchasing');


SQL Error: ORA-01776: nu se poate modif mai mult de o tabela baza prin vedere realiz prin unire
01776. 00000 -  "cannot modify more than one base table through a join view"
*Cause:    Columns belonging to more than one underlying table were either
           inserted into or updated.
*Action:   Phrase the statement as two or more separate statements.

insert into VIZ_EMP30_DEPT_*** (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY,
            HIRE_DATE, JOB_ID, DEPARTMENT_ID)
values (302,	'Colmenares',	'Karen',	'KCOLMENA',	2500,	'10-08-1999',	'PU_CLERK',	30);

SQL Error: ORA-01776: nu se poate modif mai mult de o tabela baza prin vedere realiz prin unire
01776. 00000 -  "cannot modify more than one base table through a join view"
*Cause:    Columns belonging to more than one underlying table were either
           inserted into or updated.
*Action:   Phrase the statement as two or more separate statements.

insert into VIZ_EMP30_DEPT_*** (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY,
            HIRE_DATE, JOB_ID)
values (302,	'Colmenares',	'Karen','KCOLMENA',	2500,to_date('10-08-1999', 'DD-MM-YYYY'),'PU_CLERK');
--1 row inserted.

SELECT * FROM emp_*** where employee_id =302;


CREATE OR REPLACE  VIEW VIZ_EMP30_DEPT_***
AS (SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY,
            HIRE_DATE, JOB_ID, E.DEPARTMENT_ID, DEPARTMENT_NAME
    FROM EMP_*** E, DEPT_*** D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID 
    AND E.DEPARTMENT_ID =30);
    

insert into VIZ_EMP30_DEPT_*** (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, EMAIL, SALARY,
            HIRE_DATE, JOB_ID, DEPARTMENT_ID)
values (303,	'Colmenares','Karen','KCOLMENA',	2500,to_date('10-08-1999', 'DD-MM-YYYY'),'PU_CLERK',30);

SELECT * FROM emp_*** where employee_id =303;

SELECT * FROM VIZ_EMP30_DEPT_*** where employee_id =303;