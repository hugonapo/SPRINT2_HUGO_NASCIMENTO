# Nivel 1
# Exercici 1
# A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
# Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
# Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

SELECT * 
FROM company;

SELECT *
FROM transaction;

# Exercici 2
# Utilitzant JOIN realitzaràs les següents consultes:

# Llistat dels països que estan generant vendes.

SELECT DISTINCT(c.country)
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0 AND c.country IS NOT NULL;

# Des de quants països es generen les vendes.

SELECT count(distinct(c.country)) as Total_paises
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0;

# Identifica la companyia amb la mitjana més gran de vendes.

SELECT  c.company_name, ROUND(AVG(t.amount), 2) as 'media de ventas'
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY AVG(t.amount)desc
LIMIT 1;

# Exercici 3
# Utilitzant només subconsultes (sense utilitzar JOIN):

# Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT t.id
FROM transaction t
WHERE EXISTS (
    SELECT 1
    FROM company c
    WHERE c.id = t.company_id 
      AND c.country = 'Germany' 
      AND t.declined = 0
);
						
# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name AS 'listado de compañías'
FROM company c
WHERE EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.company_id = c.id 
      AND t.amount > (
          SELECT AVG(amount)
          FROM transaction
          WHERE declined = 0)
);
															
																									
# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT * FROM company c
WHERE EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.company_id = c.id 
      AND t.id = 'NULL'
);

# Exercici 4
# La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company").
# Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
#Recorda mostrar el diagrama i realitzar una breu descripció d'aquest

CREATE TABLE credit_card
(
id varchar(15) primary key not null,
iban varchar (50) not null,
pan varchar(20) not null,
pin char(49) not null,
cvv char(3) not null,
expiring_date varchar(100) not null
);

-- creo relación entre las tablas
ALTER TABLE transaction
ADD constraint FK2 foreign key (credit_card_id) REFERENCES credit_card(id);
-- he inserido los datos de N1-Ex.4__ datos_introducir_credit.sql

SELECT *
FROM credit_card;

-- lo siguiente es la actualización del tipo de dato de la columan 'expiring_date'

UPDATE credit_card 
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');

-- Cambio el tipo de columna permanentemente
ALTER TABLE credit_card MODIFY COLUMN expiring_date DATE;


-- Compruebo si hay algun dato que no coincida para luego poder hacer la relacion entre las tabals correctamente.alter

SELECT t.id AS id_transaccion, t.credit_card_id
FROM transaction t
LEFT JOIN credit_card c ON t.credit_card_id = c.id
WHERE c.id IS NULL; 

SELECT t.id AS id_transaccion, t.company_id
FROM transaction t
LEFT JOIN company co ON t.company_id = co.id
WHERE co.id IS NULL;



# Exercici 5
# El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938.
# La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. 
# Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

# Exercici 6
# En la taula "transaction" ingressa una nova transacció amb la següent informació:
# Id 
# 108B1D1D-5B23-A76C-55EF-C568E49A99DD 
# credit_card_id 
# CcU-9999 
# company_id 
# b-9999 
# user_id 
# 9999 
# lat 
# 829.999 
# longitude 
# -117.999 
# amount 
# 111.11 
# declined 
# 0 
ALTER TABLE credit_card MODIFY iban VARCHAR(50) NULL;
ALTER TABLE credit_card MODIFY pan VARCHAR(20) NULL;
ALTER TABLE credit_card MODIFY pin CHAR(49) NULL;
ALTER TABLE credit_card MODIFY cvv CHAR(3) NULL;
ALTER TABLE credit_card MODIFY expiring_date VARCHAR(100) NULL;

INSERT INTO company(id)
VALUES('b-9999');
-- chequeo
SELECT* FROM company
WHERE id = 'b-9999';

INSERT INTO credit_card(id)
VALUES('CcU-9999');

-- chequeo
SELECT* FROM credit_card
WHERE id = 'CcU-9999';

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)      
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

-- chequeo
SELECT * FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

# Exercici 7
# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;

#Exercici 8
#Descarrega els arxius CSV que trobaràs a l'apartat de recursos:
#american_users.csv
#european_users.csv
#companies.csv
#credit_cards.csv
#transactions.csv
#Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:


-- Creaccion de tablas

CREATE DATABASE IF NOT EXISTS datos_transacciones;

CREATE TABLE IF NOT EXISTS company (
    id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(25),
    email VARCHAR(100),
    country VARCHAR(100),
    website VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(25),
    email VARCHAR(100),
    birth_date VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20), 
    address VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    user_id INT, 
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(10),
    cvv INT,
    track1 VARCHAR(255), 
    track2 VARCHAR(255), 
    expiring_date DATE
);


CREATE TABLE IF NOT EXISTS transaction (
    id VARCHAR(50) PRIMARY KEY,
    card_id VARCHAR(15),     
    business_id VARCHAR(15),  
    timestamp TIMESTAMP,
    amount DECIMAL(10, 2),
    declined TINYINT,         
    product_ids VARCHAR(255), 
    user_id INT,
    lat DECIMAL(15, 12),
    longitude DECIMAL(15, 12),
    FOREIGN KEY (card_id) REFERENCES credit_card(id),
    FOREIGN KEY (business_id) REFERENCES company(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);



UPDATE credit_card 
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');


ALTER TABLE credit_card MODIFY COLUMN expiring_date DATE;


SET SQL_SAFE_UPDATES = 1;

select *
from credit_card;

-- Inserción de datos

LOAD DATA LOCAL INFILE 'C:/mysql/companies.csv.csv' 
INTO TABLE company 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;

SELECT * FROM company;



LOAD DATA LOCAL INFILE 'C:/mysql/american_users.csv.csv' 
INTO TABLE user 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/mysql/european_users.csv.csv' 
INTO TABLE user 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;


ALTER TABLE user 
ADD COLUMN origin VARCHAR(20);


UPDATE user SET origin = 'American' WHERE country IN ('United States', 'Canada');
UPDATE user SET origin = 'European' WHERE country NOT IN ('United States', 'Canada');

SELECT * FROM user;


ALTER TABLE credit_card 
ADD COLUMN user_id INT AFTER id;


ALTER TABLE credit_card 
ADD COLUMN track1 VARCHAR(255) AFTER cvv,
ADD COLUMN track2 VARCHAR(255) AFTER track1;




DROP TABLE IF EXISTS credit_card;

CREATE TABLE credit_card (
    id VARCHAR(15) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(10),
    cvv INT,
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date DATE
);



LOAD DATA LOCAL INFILE 'C:/mysql/credit_cards.csv.csv' 
INTO TABLE credit_card 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(id, user_id, iban, pan, pin, cvv, track1, track2, @var_date)
SET expiring_date = STR_TO_DATE(TRIM(@var_date), '%m/%d/%y');

SELECT * FROM credit_card;	


DROP TABLE IF EXISTS transaction;

CREATE TABLE IF NOT EXISTS transaction (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(255),
    business_id VARCHAR(255),
    timestamp DATETIME,
    amount DECIMAL(10,2),
    declined TINYINT(1),
    product_ids VARCHAR(255),
    user_id INT,
    lat DECIMAL(10,2),
    longitude DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES user(id),         -- creación de relación entre las tablas
	FOREIGN KEY (business_id) REFERENCES company(id),
	FOREIGN KEY (card_id) REFERENCES credit_card(id)
);
select * from transaction;

LOAD DATA LOCAL INFILE 'C:/mysql/transactions.csv.csv' 
INTO TABLE transaction 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT * FROM transaction LIMIT 10;

SELECT * FROM transaction;

SELECT 'Transactions' AS Tabla, COUNT(*) AS Total_Registros FROM transaction
UNION
SELECT 'Users', COUNT(*) FROM user
UNION
SELECT 'Companies', COUNT(*) FROM company
UNION
SELECT 'Credit Cards', COUNT(*) FROM credit_card;

-- Exercici 9
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules

SELECT u.name, u.surname
FROM user u
JOIN transaction t ON u.id = t.user_id
WHERE t.declined = 0
GROUP BY u.id, u.name, u.surname
HAVING COUNT(t.id) > 80;

-- Exercici 10
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

-- no se si esta correcta y si tengo que tener en cuenta el declined

SELECT 
    c.company_name, 
    cc.iban, 
    ROUND(AVG(t.amount), 2) AS 'media de ventas'
FROM transaction t
JOIN company c ON t.business_id = c.id
JOIN credit_card cc ON t.card_id = cc.id
WHERE c.company_name = 'Donec Ltd' 
  AND t.declined = 0
GROUP BY c.company_name, cc.iban;

-- Nivel 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.


SELECT DATE(timestamp) AS fecha, SUM(amount) AS total_vendas
FROM transaction
WHERE declined = 0 
GROUP BY fecha      
ORDER BY total_vendas DESC
LIMIT 5;

-- Exercici 2
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros 
-- i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) as 'fecha', t.amount
FROM company c
JOIN transaction t on c.id = t.business_id
WHERE t.declined = 0 AND t.amount BETWEEN 350 AND 400 AND
	  DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY t.amount DESC;

-- Exercici 3
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.


SELECT 
    c.company_name, 
    COUNT(t.id) AS total_transacciones,
    IF(COUNT(t.id) >= 400, 'Más de 400', 'Menos de 400') AS clasificacion
FROM company c
JOIN transaction t ON c.id = t.business_id
GROUP BY c.id, c.company_name;

-- Exercici 4
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transaction 
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- Exercici 5
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
-- Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia.
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
CREATE VIEW `VistaMarketing` AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount),2) as 'Media de compras'
FROM company c
JOIN transaction t
ON c.id = t.business_id
WHERE t.declined = 0
GROUP BY  c.company_name, c.phone, c.country;

SELECT * FROM VistaMarketing
ORDER BY 'Media de compras' DESC;


-- Nivel 3

-- Exercici 1
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades
-- aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
--  Quantes targetes estan actives?

-- Creo tabla y numero las transacciones por tarjeta y fecha
CREATE TABLE estado_tarjetas AS
WITH TransaccionesNumeradas AS (
    SELECT 
        card_id, 
        declined,
        ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY timestamp DESC) as posicion
    FROM transaction
)
-- Filtro solo las 3 primeras posiciones y decidir estado
SELECT 
    card_id,
    IF(SUM(declined) = 3, 'Inactiva', 'Activa') as estado
FROM TransaccionesNumeradas
WHERE posicion <= 3
GROUP BY card_id;

SELECT * FROM estado_tarjetas;

SELECT COUNT(*) AS total_activas
FROM estado_tarjetas
WHERE estado = 'Activa';

-- Exercici 2
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
-- tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

-- 👉 Necessitem conèixer el nombre de vegades que s'ha venut cada producte.


CREATE TABLE product (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price VARCHAR(20), 
    colour VARCHAR(20),
    weight VARCHAR(20),
    warehouse_id VARCHAR(20)
);



LOAD DATA LOCAL INFILE 'C:/MYSQL/products.csv.csv' 
INTO TABLE product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS;


UPDATE product SET price = REPLACE(price, '$', '');


ALTER TABLE product 
MODIFY COLUMN price DECIMAL(10,2);


SELECT 
    p.id AS product_id,
    p.product_name,
    COUNT(productos_explotados.p_id) AS total_ventas
FROM product p
LEFT JOIN (
    SELECT CAST(j.p_id AS UNSIGNED) AS p_id
    FROM transaction t
    JOIN JSON_TABLE(
        CONCAT('[', t.product_ids, ']'),
        "$[*]" COLUMNS (p_id VARCHAR(50) PATH "$")
    ) AS j
    WHERE t.declined = 0 
) AS productos_explotados ON p.id = productos_explotados.p_id
GROUP BY p.id, p.product_name
ORDER BY total_ventas DESC;


ALTER TABLE credit_card ADD COLUMN estado_id INT;

ALTER TABLE estado_tarjetas
ADD CONSTRAINT FK_estado_vinculo
FOREIGN KEY (card_id) REFERENCES credit_card(id);

CREATE TABLE transaction_details (
    transaction_id VARCHAR(255),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

INSERT INTO transaction_details (transaction_id, product_id)
SELECT t.id, p.id
FROM transaction t
JOIN product p ON FIND_IN_SET(p.id, REPLACE(t.product_ids, ' ', '')) > 0;

