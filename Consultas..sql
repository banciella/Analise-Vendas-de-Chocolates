/*
------------------------------------------------------------
Projeto: Chocolate-Data-Pipeline
Autor: Felipe
Descrição:
    Este script contém consultas SQL para explorar e analisar
    a tabela ChocoVendas. Inclui filtros, agregações, joins
    e uma Window Function para cálculo de média móvel.

Objetivos:
    • Filtrar vendas por país (ex.: Brasil)
    • Atualizar status dos pedidos com base em caixas enviadas
    • Ordenar resultados por país e quantidade
    • Agregar vendas por vendedor
    • Relacionar vendas com regiões via tabela SalesTeam
    • Criar tabela auxiliar CountryRegion para mapear países
    • Usar Window Function para calcular média móvel de vendas
------------------------------------------------------------
*/

-- 1. Filtrar vendas do Brasil
SELECT * 
FROM ChocoVendas
WHERE Country = 'Brazil';

-- 2. Atualizar status dos pedidos
UPDATE ChocoVendas
SET Status = CASE
    WHEN Boxes_Shipped >= 350 THEN 'OK'
    ELSE 'NOT OK'
END;

-- 3. Ordenar pedidos por país
SELECT Order_ID, Country, Boxes_Shipped
FROM ChocoVendas 
ORDER BY Country;

-- 4. Filtrar e ordenar pedidos do Brasil por caixas enviadas
SELECT Order_ID, Country, Boxes_Shipped
FROM ChocoVendas 
WHERE Country = 'Brazil'
ORDER BY Boxes_Shipped DESC;

-- 5. Total de caixas por vendedor
SELECT Salesperson, SUM(Boxes_Shipped) AS Total_boxes
FROM ChocoVendas
GROUP BY Salesperson    
ORDER BY Salesperson DESC;

-- 6. Criar tabela SalesTeam e relacionar com vendas
CREATE TABLE SalesTeam (
    SalesPerson VARCHAR(50),
    Region VARCHAR(50)
);

INSERT INTO SalesTeam (SalesPerson, Region)
VALUES
('Felipe', 'South America'),
('João', 'Europe'),
('Fernando', 'Asia');

-- INNER JOIN: apenas correspondências
SELECT c.Order_ID, c.Country, c.Boxes_Shipped, s.Region
FROM ChocoVendas c
INNER JOIN SalesTeam s
    ON c.SalesPerson = s.SalesPerson;

-- LEFT JOIN: todas as vendas, mesmo sem região
SELECT c.Order_ID, c.Country, c.Boxes_Shipped, s.Region
FROM ChocoVendas c
LEFT JOIN SalesTeam s  
    ON c.SalesPerson = s.SalesPerson;

-- LEFT JOIN com substituição de NULL
SELECT c.Order_ID, c.Country, c.Boxes_Shipped,
       ISNULL(s.Region, 'Sem Região') AS Region
FROM ChocoVendas c
LEFT JOIN SalesTeam s  
    ON c.SalesPerson = s.SalesPerson;

-- 7. Criar tabela CountryRegion para mapear países
DROP TABLE IF EXISTS CountryRegion;

CREATE TABLE CountryRegion (
    Country VARCHAR(50),
    Region VARCHAR(50)
);

INSERT INTO CountryRegion (Country, Region)
VALUES
('Brazil', 'South America'),
('Argentina', 'South America'),
('France', 'Europe'),
('Australia', 'Oceania'),
('Germany', 'Europe'),
('India', 'Asia'),
('Japan', 'Asia');

-- JOIN com CountryRegion
SELECT c.Order_ID, c.Country, c.Boxes_Shipped, r.Region
FROM ChocoVendas c
LEFT JOIN CountryRegion r
    ON c.Country = r.Country;

-- 8. Window Function: média móvel de caixas por vendedor
SELECT Salesperson, Order_ID, Boxes_Shipped,
       AVG(Boxes_Shipped) OVER (
           PARTITION BY Salesperson
           ORDER BY Order_ID
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MediaMovel
FROM ChocoVendas;
