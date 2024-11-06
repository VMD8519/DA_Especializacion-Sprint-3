############## Nivel 1 #######################################
-- -------------------- *** EJERCICIO 1 *** --------------------------
# Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito. La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación adecuada con las otras dos tablas ("transaction" y "company"). Después de crear la tabla será necesario que ingreses la información del documento denominado "datos_introducir_credit". Recuerda mostrar el diagrama y realizar una breve descripción del mismo.

-- - Elegimos la base de datos donde vamos a trabajar 

USE transactions;

-- -- Creamos tabla credit_card 

CREATE INDEX idx_credit_card ON transaction (credit_card_id);

CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR (30), 
    pin VARCHAR (4),
    cvv INT,
    expiring_date VARCHAR (30)
    );

-- --- Consultamos datos ingresados 
    SELECT * FROM credit_card;

-- ---- Convertir las fechas de strings a date
SET SQL_safe_updates = 0;

UPDATE credit_card
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y')
WHERE expiring_date IS NOT NULL;

SET SQL_safe_updates = 1;

SELECT expiring_date  FROM credit_card;


-- ----- Modificacion del tipo de dato de la columna 'expiring_date'
ALTER TABLE credit_card
MODIFY COLUMN expiring_date DATE;

-- ------ Modificación tabla transaction para crear relacion con credit_card
ALTER TABLE transaction
ADD CONSTRAINT credit_card_fk
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

/*************************************************************/
/* Ajuste de relación entre tablas user y transaction */

-- ------ Modificación tabla USER => eliminacion FK user
ALTER TABLE user
DROP FOREIGN KEY user_ibfk_1;

-- ------ Modificación tabla transation => Creacion FK user
ALTER TABLE transaction
ADD CONSTRAINT user_ibfk_1
FOREIGN KEY (user_id) REFERENCES user(id);


-- -------------------- ***EJERCICIO 2*** --------------------------
# El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con ID CcU-2938. La información que debe mostrarse para este registro es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.

UPDATE credit_card
SET iban =  'R323456312213576817699999'
WHERE id = 'CcU-2938';

-- ---- Comprobación 

SELECT id, iban 
FROM credit_card
WHERE id = 'CcU-2938';

-- -------------------- *** EJERCICIO 3 *** --------------------------
# En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:
# Id:				108B1D1D-5B23-A76C-55EF-C568E49A99DD
# credit_card_id:	CcU-9999
# company_id:		b-9999
# user_id:			9999
# lat:				829.999
# longitude:		-117.999
# amount:			111.11
# declined:			0

-- ----- 1-	Revisión de la estructura de la tabla
DESCRIBE transaction;

-- ----- 2-	Consulta de Registros existente:
SELECT * FROM transaction;

-- -----3-	Verificación de Relaciones entre Tablas:
/** CREDIT_CARD_ID (FK)**/
-- ----- Utilizo esta declaracion para verificar las relaciones y consultas posteriores a la insercion de registros

SELECT* FROM credit_card
WHERE id = 'CcU-9999';

-- ---- Insercion de registros
INSERT INTO credit_card (id) 
VALUE ('CcU-9999');

/** COMPANY_ID (FK) **/
-- ----- Utilizo esta declaracion para verificar las relaciones y consultas posteriores a la insercion de registros
SELECT* FROM company
WHERE id = 'b-9999';

-- ---- Insercion de registros
INSERT INTO company (id)
VALUE ('b-9999');

/** USER_ID (FK) **/
-- ----- Utilizo esta declaracion para verificar las relaciones y consultas posteriores a la insercion de registros
SELECT* FROM user
WHERE id = '9999';

-- ---- Insercion de registros
INSERT INTO user (id)
VALUE ('9999');


-- ----- 4-	Inserción de los nuevos registros a la tabla transaction:

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', 82.9999, -117.999, CURRENT_TIMESTAMP, 111.11, 0);

-- Comprobacion 
SELECT * FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- -------------------- *** EJERCICIO 4 *** --------------------------
# Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.

-- Eliminacion de columna PAN
ALTER TABLE credit_card
DROP COLUMN pan; 

-- Comprobacion 
DESCRIBE credit_card;


############## Nivel 2 #######################################
-- -------------------- *** EJERCICIO 1 *** --------------------------
#Elimina de la tabla transacción el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos.

-- Eliminacion de registro
DELETE FROM transaction
WHERE id= '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- Comprobacion 
SELECT *
FROM transaction
WHERE id= '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- -------------------- *** EJERCICIO 2 *** --------------------------
/*La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.*/

CREATE VIEW VistaMarketing AS 
SELECT company_name, phone, country, avg(amount) AS Media_de_compras
FROM company
JOIN transaction
ON company.id=company_id
WHERE declined=0
GROUP BY 1,2,3
ORDER BY Media_de_compras DESC;

SELECT* FROM vistamarketing;
-- -------------------- *** EJERCICIO 3 *** --------------------------
#Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"

SELECT *
FROM VistaMarketing
WHERE COUNTRY='Germany';

############## Nivel 3 #######################################
-- -------------------- *** EJERCICIO 1 *** --------------------------
/*La próxima semana tendrás una nueva reunión con los gerentes de marketing. Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:*/

-- --- TABLA COMPANY ---
-- 1- Revision de estructura de la tabla

DESCRIBE company;

-- 2- Comandos
-- -----ELIMINACION DE COLUMNA
ALTER TABLE company
DROP COLUMN website;

/* COMPROBACION*/
DESCRIBE company;

-- --- TABLA CREDIT_CARD ---
-- 1- Revision de estructura de la tabla

DESCRIBE credit_card;

-- 2- Comandos
-- a) ALTERACION DE TIPO DE DATO

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR (10); 

-- b) AGREGACION DE COLUMNA

ALTER TABLE credit_card
ADD fecha_actual DATE;

/* COMPROBACION*/
DESCRIBE credit_card;

-- --- DATA_USER ---
-- 1- Revision de estructura de la tabla

DESCRIBE user;

-- 2- Comandos
-- a) ALTERACION DEL NOMBRE DE UNA TABLA

RENAME TABLE user TO data_user;

-- b) ALTERACION DEL NOMBRE DE UNA COLUMNA

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

/* COMPROBACION*/

DESCRIBE data_user;

-- --- TABLA TRANSACTION ---
-- 1- Revision de estructura de la tabla

DESCRIBE transaction;

-- 2- Comandos
-- a) AGREGACION DE RESTRICCIONES A COLUMNAS

ALTER TABLE transaction
MODIFY COLUMN user_id INT NOT NULL;

ALTER TABLE transaction 
MODIFY COLUMN credit_card_id VARCHAR(15) NOT NULL; 


/* COMPROBACION*/
DESCRIBE transaction;

-- -------------------- *** EJERCICIO 2 *** --------------------------
/*La empresa también te solicita crear una vista llamada "Informe Técnico" que contenga la siguiente información:

ID de la transacción
Nombre del usuario/a
Apellido del usuario/a
IBAN de la tarjeta de crédito usada.
Nombre de la compañía de la transacción realizada.
Asegúrate de incluir información relevante de ambas tablas y utiliza alias para cambiar de nombre columnas según sea necesario.

Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.*/

CREATE VIEW InformeTecnico AS
SELECT transaction.id AS ID_Transaction, amount as Amount_transaction, timestamp AS Fecha_Hora, declined , name AS Name_user, surname as Surname_user, iban AS Iban_tarjeta, data_user.country as Country_user, email as Emails_user, company_name,  company.country AS Country_company
FROM transaction
JOIN data_user
ON user_id=data_user.id
JOIN credit_card
ON credit_card_id= credit_card.id
JOIN company
ON company_id=company.id
ORDER BY 1 DESC;

SELECT* FROM InformeTecnico;

