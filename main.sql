/* Mi preparo a creare la tabella vendite e dettagli_vendite (Entità) con i relativi attributi e la chiave primaria. 
Ogni attributo avrà il suo dominio (es. Varcher,Char, NULL,). Poi inserisco i dati per ogni tabella.*/


# creo le tabelle Vendite e dettagli_vendite

CREATE TABLE Vendite (
    ID_Transazione INT PRIMARY KEY,
    CategoriaProdotto VARCHAR(255),
    CostoVendita DECIMAL(9, 2),
    PercentualeSconto DECIMAL(5, 2)
);
CREATE TABLE dettagli_vendite (
    ID_Transazione INT PRIMARY KEY,
    ID_Cliente INT,
    DataAcquisto DATE,
    Quantita INT,
    FOREIGN KEY (ID_Transazione) REFERENCES Vendite(ID_Transazione)
);

# inserisco dati nella tabella Vendite

INSERT INTO Vendite (ID_Transazione, CategoriaProdotto, CostoVendita, PercentualeSconto)
VALUES
    (1, 'Elettronica', 950.5, 10),
    (2, 'Elettronica', 1200.00, 52),
    (3, 'Giochi', 250.00, 12.50),
    (4, 'Cibo', 45.00, 5),
    (5, 'Abbigliamento', 80.00, 5),
    (6, 'Elettronica', 600.00, 30),
    (7, 'Giochi', 180.00, 15),
    (8, 'Cibo', 35.00, 3.50),
    (9, 'Abbigliamento', 95.00, 10),
    (10, 'Elettronica', 750.00, 40),
    (11, 'Giochi', 300.00, 20),
    (12, 'Cibo', 25.00, 2.50),
    (13, 'Abbigliamento', 110.00, 59),
    (14, 'Elettronica', 900.00, 45),
    (15, 'Giochi', 350.00, 18),
    (16, 'Cibo', 40.00, 4),
    (17, 'Abbigliamento', 130.00, 15),
    (18,'Cibo',500,59),
    (19,'Abbigliamento',980,51),
    (20,'Elettronica',1005,0),
    (21,'Cibo',569,62),
    (22,'Elettronica',2900,13),
    (23,'Cibo',5800,45),
    (24,'Abbigliamento',100,0),
    (25,'Giochi',3800,49),
    (26,'Elettronica',102,0),
    (27,'Abbigliamento',350,90),
    (28,'Cibo',45,0),
    (29,'Abbigliamento',300,30),
    (30,'Elettronica',1500,10);

/* inserisco dati nella tabella dettagli_vendite, 
Prof avevo già creato id transazione e id cliente prima di correggere 
la consegna del compito, lascio comunque la colonna id cliente, mi servirà per pormi domande extra  */

INSERT INTO dettagli_vendite (ID_Transazione, ID_Cliente, DataAcquisto, Quantita)
VALUES
    (1,123,'2023-1-10',15),
    (2,124,'2023-2-28',10),
    (3,125,'2023-3-30',4),
    (4,126,'2023-4-12',1),
    (5,126,'2023-5-4',2),
    (6,123,'2023-6-12',15),
    (7,127,'2023-7-3',18),
    (8,125,'2023-8-13',25),
    (9,124,'2023-9-9',2),
    (10,125,'2023-10-19',4),
    (11,124,'2023-11-24',10),
    (12,123,'2023-12-20',18),
    (13,125,'2023-11-12',20),
    (14,126,'2023-7-1',54),
    (15,123,'2023-2-13',12),
    (16,126, '2023-8-12',13),
    (17,124,'2023-5-2',15),
    (18,127,'2023-11-5',20),
    (19,127,'2023-2-6',5),
    (20,124,'2023-9-10',45),
    (21,128,'2023-2-18',30),
    (22,128,'2023-3-5',10),
    (23,128,'2023-12-15',50),
    (24,128,'2023-11-5',10),
    (25,127,'2023-12-3',15),
    (26,124,'2023-6-15',10),
    (27,125,'2023-4-2',5),
    (28,124,'2023-5-6',15),
    (29,127,'2023-9-12',10),
    (30,126,'2023-12-12',5);

# Seleziona tutte le vendite avvenute in una specifica data, prendiamo il mese di Febbraio

SELECT *FROM dettagli_vendite
WHERE MONTH(DataAcquisto) = 2 AND YEAR(DataAcquisto) = 2023;

# Elenco vendite con sconti maggiori al 50%

SELECT * FROM Vendite
WHERE (PercentualeSconto) > 50;

# Calcolare totale del costoVendita per categoria.

SELECT CategoriaProdotto, SUM(CostoVendita) AS TotaleVendite
FROM Vendite
GROUP BY CategoriaProdotto;

# trova il numero totale dei prodotti venduti per singola categoria

SELECT CategoriaProdotto, SUM(Quantita) AS NumeroTotaleProdotti
FROM Vendite V
JOIN dettagli_vendite DV ON V.ID_Transazione = DV.ID_Transazione
GROUP BY CategoriaProdotto;

#Seleziona le vendite dell'ultimo trimestre

SELECT DV. * FROM dettagli_vendite DV
JOIN Vendite V ON DV.ID_Transazione = V.ID_Transazione
WHERE YEAR(DV.DataAcquisto) = YEAR(CURRENT_DATE)
  AND QUARTER(DV.DataAcquisto) = 4;

#Raggruppa le vendite per mese e calcola il totale delle vendite per ogni mese

SELECT
    YEAR(DV.DataAcquisto) AS Anno,
    MONTH(DV.DataAcquisto) AS Mese,
    SUM(V.CostoVendita) AS TotaleVendite
FROM dettagli_vendite DV
JOIN Vendite V ON DV.ID_Transazione = V.ID_Transazione
GROUP BY YEAR(DV.DataAcquisto), MONTH(DV.DataAcquisto)
ORDER BY Anno, Mese;

#Trova la categoria con lo sconto medio più alto

SELECT CategoriaProdotto, AVG(PercentualeSconto) AS ScontoMedio
FROM Vendite
GROUP BY CategoriaProdotto
ORDER BY ScontoMedio DESC LIMIT 1;

/* Confronta le vendite mese per mese per vedere l'incremento o il decremento delle vendite. 
Calcola l’incremento o decremento mese per mese */

WITH VenditeMesePrecedente AS (
  SELECT
    YEAR(DataAcquisto) AS Anno,
    MONTH(DataAcquisto) AS Mese,
    SUM(CostoVendita) AS VenditeMesePrecedente
  FROM dettagli_vendite V
  JOIN Vendite D ON V.ID_Transazione = D.ID_Transazione
  GROUP BY Anno, Mese
),
VenditeCorrenti AS (
  SELECT
    YEAR(DataAcquisto) AS Anno,
    MONTH(DataAcquisto) AS Mese,
    SUM(CostoVendita) AS VenditeCorrenti
  FROM dettagli_vendite V
  JOIN Vendite D ON V.ID_Transazione = D.ID_Transazione
  GROUP BY Anno, Mese
)
SELECT
  VC.Anno,
  VC.Mese,
  VC.VenditeCorrenti,
  COALESCE(VC.VenditeCorrenti - VMP.VenditeMesePrecedente, VC.VenditeCorrenti) AS IncrementoDecremento
FROM VenditeCorrenti VC
LEFT JOIN VenditeMesePrecedente VMP ON VC.Anno = VMP.Anno AND VC.Mese = VMP.Mese + 1
ORDER BY VC.Anno, VC.Mese;

#Confronta le vendite totali in diverse stagioni.

 SELECT
  YEAR(DataAcquisto) AS Anno,
  CASE
    WHEN MONTH(DataAcquisto) BETWEEN 1 AND 6 THEN 'InvernoPrimavera'
    WHEN MONTH(DataAcquisto) BETWEEN 7 AND 12 THEN 'EstateAutunno'
 END AS Stagione,
     SUM(CostoVendita) AS VenditeTotali
FROM dettagli_vendite V
JOIN Vendite D ON V.ID_Transazione = D.ID_Transazione
GROUP BY Anno, Stagione;

# i 5 clienti con maggior numero di acquisti
SELECT
  ID_Cliente,
  COUNT(DISTINCT ID_Transazione) AS NumeroAcquisti
FROM dettagli_vendite
GROUP BY ID_Cliente
ORDER BY NumeroAcquisti DESC
LIMIT 5;

# QUal è il cliente che ha ricevuto una media dello sconto minore? 

 SELECT
  DV.ID_Cliente,
  AVG(V.PercentualeSconto) AS MediaSconto
FROM dettagli_vendite DV
JOIN Vendite V ON DV.ID_Transazione = V.ID_Transazione
GROUP BY DV.ID_Cliente
ORDER BY MediaSconto ASC
LIMIT 1;

# quanto ha acquistato ogni singolo cliente e cosa

SELECT
  DV.ID_Cliente,
  SUM(V.CostoVendita) AS VenditaTotale,
  GROUP_CONCAT(DISTINCT V.CategoriaProdotto SEPARATOR ', ') AS Prodotto
FROM dettagli_vendite DV
JOIN Vendite V ON DV.ID_Transazione = V.ID_Transazione
GROUP BY DV.ID_Cliente;