-- Script de consultas a las tablas de hr
-- Creado por : BD II
-- Fecha de creacion : 19-Nov-2020
-- Modificado : 
-- Fecha ultima modificacion : 
-- Descripcion

--1. Elabore una consulta que reporte los nombres de las ciudades que tienen al
--menos un departamento en el que trabajan entre 5 y 15 empleados.
SELECT L.CITY "Ciudades"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
GROUP BY L.CITY
HAVING COUNT(E.EMPLOYEE_ID) BETWEEN 5 AND 15;

-- 2. Con el fin de realizar una clasificación interna de la compañía, se desea proyectar
-- una categoría a los empleados según el salario que recibe, el empleado será de
-- categoría “Elite” si gana 20000, “Gold” si gana 15000, “Premium” si gana 10000 y
-- “Silver” para los que ganen un valor de salario diferente a los anteriores. Se desea
-- imprimir un reporte que incluya lo siguiente:
-- - Nombre Completo (Formato -> Apellido, NOMBRE)
-- - Tiempo en meses trabajando para la compañía, no tenga en cuenta los decimales
-- - Salario (incluyendo comisión y anteponiendo a la cifra el signo de dólar)
-- - Fecha de Contratación (Formato -> Nombre del día, Número de día/Nombre del
-- Mes/Dos últimos dígitos del año)
-- - Categoría Proyectada. 
SELECT LAST_NAME "Apellidos",
UPPER(FIRST_NAME) "NOMBRE",
TRUNC(MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE), 0) "Meses trabajando",
SALARY || '' || COMMISSION_PCT || '' || '$' "Salario con comision",
REPLACE(TO_CHAR(HIRE_DATE, 'DAY/DD/MONTH/YY'), ' ') "Fecha de contratacion",
DECODE(SALARY, 20000, 'Elite', 15000, 'Gold', 10000, 'Premium', 'Silver') "Categoria"
FROM EMPLOYEES;

--3. Muestre los países en los que al menos tienen cinco empleados que desempeñan
--los cargos de SALES MANAGER o PROGRAMMER y que hayan sido contratados
--en un mes par en los últimos 5 años
SELECT C.COUNTRY_NAME "Paises"
FROM EMPLOYEES E, JOBS J, DEPARTMENTS D, LOCATIONS L, COUNTRIES C
WHERE E.JOB_ID = J.JOB_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID
AND MOD(EXTRACT(MONTH FROM E.HIRE_DATE), 2) = 0
AND UPPER(J.JOB_TITLE) LIKE 'SALES MANAGER' OR UPPER(J.JOB_TITLE) LIKE 'PROGRAMMER'
AND (EXTRACT(YEAR FROM E.HIRE_DATE)) BETWEEN (EXTRACT(YEAR FROM CURRENT_DATE) - 5) AND (EXTRACT(YEAR FROM CURRENT_DATE))
GROUP BY C.COUNTRY_NAME
HAVING COUNT(E.EMPLOYEE_ID) >= 5;

--4. Reporte los años impares en los que se han contratado más de 7 empleados.
SELECT REPLACE(TO_CHAR(HIRE_DATE, 'YY'), ' ') "Anios"
FROM EMPLOYEES
WHERE MOD(EXTRACT(YEAR FROM HIRE_DATE), 2) != 0
GROUP BY REPLACE(TO_CHAR(HIRE_DATE, 'YY'), ' ')
HAVING COUNT(EMPLOYEE_ID) > 7;

--5. Nombre de los empleados cuya sumatoria del primer y cuatro dígitos del teléfono
--es par y que sean supervisores de al menos un empleado.
SELECT M.FIRST_NAME "Empleados"
FROM EMPLOYEES M, EMPLOYEES E
WHERE M.EMPLOYEE_ID = E.MANAGER_ID
AND MOD((
CAST(SUBSTR(REPLACE(M.PHONE_NUMBER, '.', ''),1,1) AS NUMBER) +
CAST(SUBSTR(REPLACE(M.PHONE_NUMBER, '.', ''),4,1) AS NUMBER)),2) = 0
GROUP BY M.FIRST_NAME
HAVING COUNT(E.MANAGER_ID) >=1;

--6. Reporte el nombre completo, la cantidad de meses que ha trabajado y la edad
--del empleado (asumiendo que todos fueron contratados a la edad de 18 años) de
--los empleados de una región ingresada por el usuario.
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME "Empleados",
((EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM E.HIRE_DATE))*12) "Meses trabajados",
((EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM E.HIRE_DATE))+18) "Edad"
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID
AND L.COUNTRY_ID = C.COUNTRY_ID
AND C.REGION_ID = R.REGION_ID
AND UPPER(R.REGION_NAME) LIKE '&REGION';