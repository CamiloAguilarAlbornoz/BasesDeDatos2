-- Script de consultas a las tablas de hr
-- Creado por : BD II
-- Fecha de creacion : 11-Nov-2020
-- Modificado : 
-- Fecha ultima modificacion : 
-- Descripcion

--1. Se desea generar una categoría a los empleados, el reporte que se le pide debe
--mostrar lo siguiente:
--Nombre Completo
--Tiempo en años trabajando para la compañía
--Salario
--Fecha de Contratación (Formato Número de día – Nombre del Mes -Dos últimos dígitos del año)
--Categoría, A si gana 10000, B si gana 5000, C si gana 1000, D para los demás salarios. 
SELECT FIRST_NAME || ' ' || LAST_NAME "FULL NAME",
TRUNC((CURRENT_DATE - HIRE_DATE) / 365)  "YEARS WORKING",
SALARY,
REPLACE(TO_CHAR(HIRE_DATE, 'DD/MONTH/YY'), ' ') "HIRE DATE",
DECODE(SALARY, 10000, 'A', 5000, 'B', 1000, 'C', 'D') "CATEGORY"
FROM EMPLOYEES;

--2. Muestre el nombre completo de los empleados que ocupan alguno de los
--siguientes códigos de cargos 'IT_PROG', 'SA_MAN'; y fueron contratados entre el año 2005 y 2010.
SELECT FIRST_NAME || ' ' || LAST_NAME "FULL NAME"
FROM EMPLOYEES
WHERE JOB_ID LIKE 'IT_PROG' OR JOB_ID LIKE 'SA_MAN'
AND EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 2005 AND 2010;

--3. Nombre de los departamentos que no tienen jefe.
SELECT DEPARTMENT_NAME "DEPARTMENTS" 
FROM DEPARTMENTS
WHERE MANAGER_ID IS NULL;

--4. Nombre de los empleados cuya sumatoria de los tres primeros dígitos del teléfono es par.
SELECT FIRST_NAME "NAME"
FROM EMPLOYEES
WHERE MOD((
CAST(SUBSTR(PHONE_NUMBER,1,1) AS NUMBER) + 
CAST(SUBSTR(PHONE_NUMBER,2,1) AS NUMBER) +
CAST(SUBSTR(PHONE_NUMBER,3,1) AS NUMBER)),2) = 0;

--5. Muestre el nombre de los trabajos que tienen una diferencia de más de 10000 
--dólares entre el mínimo y el máximo salario sugerido.
SELECT JOB_TITLE
FROM JOBS
WHERE (MAX_SALARY - MIN_SALARY) > 10000;

--6. Nombre de los países ubicados en la región 4. 
SELECT COUNTRY_NAME, REGION_ID 
FROM COUNTRIES
WHERE REGION_ID = 4;

--7. Nombre de los empleados que ganan más de 6500 dólares y su correo inicia por S.
SELECT FIRST_NAME "NAME"
FROM EMPLOYEES
WHERE SALARY > 6500
AND EMAIL LIKE 'S%';

--8. Nombre de los empleados y una columna que diga si tiene o no comisión.
SELECT FIRST_NAME "NAME",
DECODE(COMMISSION_PCT, NULL, 'HE HAS NOT', 'HE HAS') "HE HAS OR NOT"
FROM EMPLOYEES;

--9. Inserte un registro en la tabla empleados solamente con los campos necesarios.
INSERT INTO EMPLOYEES VALUES(207, NULL, 'AGUILAR', 'camiloaaguilara@gmail.com', NULL, '29/09/2018', 'IT_PROG',
NULL,
NULL,
NULL,
NULL);

-- 10. Inserte un registro en la tabla empleados con todos los campos
INSERT INTO EMPLOYEES VALUES(208, 'Silvana', 'Nieto', 'silvana.nieto@gmail.com', 3134854906, '03/10/2018', 'AC_ACCOUNT', 
50000, .50, 207, 50);

--Nombre de los empleados ubicados en america que ganan mas de 5000 dolares incluyendo comision
SELECT FIRST_NAME "NAME"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R 
WHERE SALARY+(SALARY*NVL(COMMISSION_PCT,0)) > 5000
E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID
AND C.REGION_ID = R.REGION_ID
AND UPPER(R.REGION_NAME) LIKE 'AMERICAS';

--Nomina a pagar por documento sin comision
SELECT DEPARTMENT_NAME "DEPARTMENT", SUM(SALARY) "NOMINA"
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
HAVING SUM(SALARY) >= 10000
AND SUM(SALARY) <= 20000
ORDER BY DEPARTMENT_NAME; -- ORDER BY por defecto es ascendente, si se quiere cambiar se coloca DESC