-- Script de consultas a las tablas de hr
-- Creado por : BD II
-- Fecha de creacion : 16-Nov-2020
-- Modificado : 
-- Fecha ultima modificacion : 
-- Descripcion

--1) Realice una consulta que permita saber la cantidad de empleados contratados por mes y año.
SELECT COUNT(EMPLOYEE_ID) "Cantidad de empleados",
REPLACE(TO_CHAR(HIRE_DATE, 'MONTH/YYYY'), ' ') "Fecha contratacion"
FROM EMPLOYEES
GROUP BY REPLACE(TO_CHAR(HIRE_DATE, 'MONTH/YYYY'), ' ');

--2) Elabore un reporte que permita conocer los nombres completos de los empleados
--que ganan más que su jefe y que trabajan en la región "Europe".
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME "Nombre Completo"
FROM EMPLOYEES E, EMPLOYEES M, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.MANAGER_ID = M.EMPLOYEE_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID
AND C.REGION_ID = R.REGION_ID
AND UPPER(R.REGION_NAME) LIKE UPPER('Europe')
AND E.SALARY > M.SALARY; 

--3) Nombre de los departamentos que no tienen empleados asignados.
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
MINUS
SELECT DEPARTMENT_ID
FROM EMPLOYEES;

--4) Nombre de los empleados que trabajan en París.
SELECT FIRST_NAME "Empleados"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
AND D.LOCATION_ID=L.LOCATION_ID
AND UPPER(L.CITY) LIKE 'PARIS';

--5) El nombre de cada departamento, ciudad donde se localiza, número de
--empleados y promedio de salario de cada departamento. Haga redondeo del
--promedio del salario a dos cifras decimales.
SELECT D.DEPARTMENT_NAME "Departamentos",
L.CITY "Ciudad",
COUNT(E.EMPLOYEE_ID) "Total Empleados",
ROUND(AVG(E.SALARY), 2) "Promedio Salario"
FROM DEPARTMENTS D, LOCATIONS L, EMPLOYEES E
WHERE D.LOCATION_ID = L.LOCATION_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY L.CITY, D.DEPARTMENT_NAME;

--6) El nombre del empleado, la fecha de contratación, el día de la semana en que se
--contrató y TODA la fecha en números romanos.
SELECT FIRST_NAME "Empleado",
HIRE_DATE "Fecha Contratacion",
TO_CHAR(HIRE_DATE, 'DAY') "Dia contratacion",
TO_CHAR(EXTRACT(DAY FROM HIRE_DATE), 'RM') "Dia en Romano",
TO_CHAR(EXTRACT(MONTH FROM HIRE_DATE), 'RM') "Mes en Romano",
TO_CHAR(EXTRACT(YEAR FROM HIRE_DATE), 'RM') "Anio en romano"
FROM EMPLOYEES;

--7) El nombre del departamento, el nombre del empleado que lo dirige y la ciudad en
--la que se encuentra.
SELECT D.DEPARTMENT_NAME "Departamento",
E.FIRST_NAME "Director",
L.CITY "Ciudad"
FROM DEPARTMENTS D, EMPLOYEES E, LOCATIONS L
WHERE D.MANAGER_ID = E.MANAGER_ID
AND D.LOCATION_ID = L.LOCATION_ID;

--8) Ciudad que tiene más de 5 empleados que ganan 5000 o más dólares.
SELECT COUNT(E.EMPLOYEE_ID) "Cantidad de empleados",
L.CITY "Ciudad"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND E.SALARY >= 5000
GROUP BY L.CITY
HAVING COUNT(E.EMPLOYEE_ID) > 5;

--9) Tiempo promedio en años trabajado por los empleados de la compañía.
SELECT SUM((EXTRACT(YEAR FROM J.END_DATE)-EXTRACT(YEAR FROM J.START_DATE))) "Promedio anios trabajados",
E.FIRST_NAME || ' ' || E.LAST_NAME "Empleado"
FROM EMPLOYEES E, JOB_HISTORY J
WHERE E.EMPLOYEE_ID = J.EMPLOYEE_ID
GROUP BY E.FIRST_NAME || ' ' || E.LAST_NAME;

--10) Reporte del promedio de salario por departamento, incluyendo solo los
--empleados cuyo código es par.
SELECT AVG(E.SALARY) "Promedio del salario",
D.DEPARTMENT_NAME "Departamento"
FROM EMPLOYEES E, DEPARTMENTS D
WHERE MOD(E.EMPLOYEE_ID, 2) = 0
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;

--11) Cantidad de empleados, sin comisión, por país.
SELECT COUNT(E.EMPLOYEE_ID) "Cantidad sin comision",
C.COUNTRY_NAME "Pais"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C
WHERE E.COMMISSION_PCT IS NULL
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID
GROUP BY C.COUNTRY_NAME;