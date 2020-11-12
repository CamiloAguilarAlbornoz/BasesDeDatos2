-- Script de creacion de base de datos Hospital-Oracle
-- Creado por : BD II
-- Fecha de creacion : 06-Nov-2020
-- Modificado : 
-- Fecha ultima modificacion : 
-- Descripcion

-------- Creacion de estructura de las tablas
CREATE TABLE pruebas (
    id_prueba          NUMBER(2)     NOT NULL,
    nombre_prueba      VARCHAR2(20)  NOT NULL,
    descripcion_prueva VARCHAR2(140) NOT NULL,
    CONSTRAINT pru_pk_id PRIMARY KEY (id_prueba)
);

CREATE TABLE categorias (
    id_categoria     NUMBER(2)    NOT NULL,
    nombre_categoria VARCHAR2(30) NOT NULL,
    CONSTRAINT cat_pk_id PRIMARY KEY (id_categoria)
);

CREATE TABLE especialidades (
    id_especialidad     NUMBER(3)    NOT NULL,
    nombre_especialidad VARCHAR2(30) NOT NULL,
    CONSTRAINT esp_pk_id PRIMARY KEY (id_especialidad)
);

CREATE TABLE quirofanos (
    id_quirofano NUMBER(2) NOT NULL,
    CONSTRAINT qui_pk_id PRIMARY KEY (id_quirofano)
);

CREATE TABLE operaciones (
    id_operacion     NUMBER(3)    NOT NULL,
    nombre_operacion VARCHAR2(50) NOT NULL,
    CONSTRAINT ope_pk_id PRIMARY KEY (id_operacion)
);

------- Creacion de dominios 

CREATE TABLE pacientes (
    id_paciente        NUMBER(8)    NOT NULL,
    nombre_paciente    VARCHAR2(20) NOT NULL,
    apellido_paciente  VARCHAR2(20) NOT NULL,
    seguro_social      VARCHAR2(15) NOT NULL,
    direccion_paciente VARCHAR2(50) NOT NULL,
    telefono_paciente  VARCHAR2(30) NOT NULL,
    estado_paciente    CHAR(1)      NOT NULL,
    CONSTRAINT pac_pk_id PRIMARY KEY (id_paciente)
);

CREATE TABLE pabellones (
    id_pabellon        NUMBER(2)    NOT NULL,
    nombre_pabellon    VARCHAR2(20) NOT NULL,
    ubicacion_pabellon VARCHAR2(50) NOT NULL,
    CONSTRAINT pab_pk_id PRIMARY KEY (id_pabellon)
);

CREATE TABLE muestras (
    id_muestra     NUMBER(3)    NOT NULL,
    nombre_muestra VARCHAR2(30) NOT NULL,
    CONSTRAINT mue_pk_id PRIMARY KEY (id_muestra)
);

CREATE TABLE factores (
    id_factor     NUMBER(2)    NOT NULL,
    nombre_factor VARCHAR2(20) NOT NULL,
    CONSTRAINT fac_pk_id PRIMARY KEY (id_factor)
);

CREATE TABLE medicos (
    id_medico        NUMBER(8)    NOT NULL,
    id_especialidad  NUMBER(3)    NOT NULL,
    id_categoria     NUMBER(2)    NOT NULL,
    nombre_medico    VARCHAR2(30) NOT NULL,
    apellido_medico  VARCHAR2(50) NOT NULL,
    direccion_medico VARCHAR2(50) NOT NULL,
    telefono_medico  VARCHAR2(50) NOT NULL,
    CONSTRAINT med_pk_id PRIMARY KEY (id_medico)
);

CREATE TABLE laboratorios (
    id_laboratorio           NUMBER(2)    NOT NULL,
    id_medico                NUMBER(8)    NOT NULL,
    id_pabellon              NUMBER(2)    NOT NULL,
    denominacion_laboratorio VARCHAR2(20) NOT NULL,
    CONSTRAINT lab_pk_id PRIMARY KEY (id_laboratorio)
);

CREATE TABLE ordenes (
    numero_orden    NUMBER(5) NOT NULL,
    fecha_orden     DATE      NOT NULL,
    id_prueba       NUMBER(2) NOT NULL,
    id_muestra      NUMBER(3) NOT NULL,
    id_laboratorio  NUMBER(2) NOT NULL,
    fecha_recepcion DATE      NOT NULL,
    CONSTRAINT ord_pk_num PRIMARY KEY (numero_orden)
);

CREATE TABLE resultados (
    numero_orden NUMBER(5)   NOT NULL,
    id_factor    NUMBER(2)   NOT NULL,
    resultado    NUMBER(5,2) NOT NULL,
    CONSTRAINT res_pk_id PRIMARY KEY (numero_orden, id_factor)
);

CREATE TABLE informes (
    id_paciente   NUMBER(8)     NOT NULL,
    id_medico     NUMBER(8)     NOT NULL,
    fehca_informe DATE          NOT NULL,
    pronostico    VARCHAR2(140) NOT NULL,
    diagnostico   VARCHAR2(140) NOT NULL,
    tratamiento   VARCHAR2(140) NOT NULL,
    CONSTRAINT inf_pk_id PRIMARY KEY (id_paciente, id_medico, fehca_informe)
);

CREATE TABLE intervenciones (
    id_intervencion    NUMBER(3) NOT NULL,
    id_quirofano       NUMBER(2) NOT NULL,
    id_operacion       NUMBER(3) NOT NULL,
    id_paciente        NUMBER(8) NOT NULL,
    id_medico          NUMBER(8) NOT NULL,
    fecha_intervencion DATE      NOT NULL,
    turno_intervencion CHAR(1)   NOT NULL,
    CONSTRAINT int_pk_id PRIMARY KEY (id_intervencion)
);

------- Creacion de las reglas del negocio
ALTER TABLE pacientes ADD(
    CONSTRAINT pac_ck_est CHECK (estado_paciente IN ('A'/*Ambulatorio*/,'I'/*Interno*/))
);

ALTER TABLE medicos ADD (
    CONSTRAINT med_fk_idc FOREIGN KEY (id_categoria)    REFERENCES categorias(id_categoria),
    CONSTRAINT med_fk_ide FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)
);

ALTER TABLE laboratorios ADD (
    CONSTRAINT lab_fk_idm FOREIGN KEY (id_medico)   REFERENCES medicos(id_medico),
    CONSTRAINT lab_fk_idl FOREIGN KEY (id_pabellon) REFERENCES pabellones(id_pabellon)
);

ALTER TABLE ordenes ADD (
    CONSTRAINT ord_fk_idp FOREIGN KEY (id_prueba)      REFERENCES pruebas(id_prueba),
    CONSTRAINT ord_fk_idl FOREIGN KEY (id_laboratorio) REFERENCES laboratorios(id_laboratorio),
    CONSTRAINT ord_fk_idm FOREIGN KEY (id_muestra)     REFERENCES muestras(id_muestra)
);

ALTER TABLE resultados ADD (
    CONSTRAINT res_fk_num FOREIGN KEY (numero_orden) REFERENCES ordenes(numero_orden),
    CONSTRAINT res_fk_idf FOREIGN KEY (id_factor)    REFERENCES factores(id_factor)
);

ALTER TABLE informes ADD (
    CONSTRAINT inf_fk_idm FOREIGN KEY (id_medico)   REFERENCES medicos(id_medico),
    CONSTRAINT inf_fk_idp FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);

ALTER TABLE intervenciones ADD (
    CONSTRAINT int_fk_idq FOREIGN KEY (id_quirofano) REFERENCES quirofanos(id_quirofano),
    CONSTRAINT int_fk_ido FOREIGN KEY (id_operacion) REFERENCES operaciones(id_operacion),
    CONSTRAINT int_fk_idp FOREIGN KEY (id_paciente)  REFERENCES pacientes(id_paciente),
    CONSTRAINT int_fk_idm FOREIGN KEY (id_medico)    REFERENCES medicos(id_medico),
    CONSTRAINT int_ck_tur CHECK (turno_intervencion IN ('M'/*Mañana*/,'T'/*Tarde*/, 'N'/*Noche*/))
);

------------------ Eliminar tablas --------------------
DROP TABLE pruebas CASCADE CONSTRAINT;

DROP TABLE categorias CASCADE CONSTRAINT;

DROP TABLE especialidades CASCADE CONSTRAINT;

DROP TABLE quirofanos CASCADE CONSTRAINT;

DROP TABLE operaciones CASCADE CONSTRAINT;

DROP TABLE pacientes CASCADE CONSTRAINT;

DROP TABLE pabellones CASCADE CONSTRAINT;

DROP TABLE muestras CASCADE CONSTRAINT;

DROP TABLE factores CASCADE CONSTRAINT;

DROP TABLE medicos CASCADE CONSTRAINT;

DROP TABLE laboratorios CASCADE CONSTRAINT;

DROP TABLE ordenes CASCADE CONSTRAINT;

DROP TABLE resultados CASCADE CONSTRAINT;

DROP TABLE informes CASCADE CONSTRAINT;

DROP TABLE intervenciones CASCADE CONSTRAINT;