/* Creating the database */
CREATE TABLE brewies(
	SALES_ID INT,
	SALES_REP VARCHAR,
	EMAILS VARCHAR,
	BRANDS VARCHAR,
	PLANT_COST INT,
	UNIT_PRICE INT,
	QUANTITY INT,
	COST INT,
	PROFIT INT,
	COUNTRIES VARCHAR,
	REGION VARCHAR,
	MONTHS VARCHAR,
	YEARS INT);
	
COPY brewies FROM 'C:\Program Files\PostgreSQL\11\tutorial data\utiva\International_Breweries (1).csv' DELIMITER ',' CSV HEADER;

SELECT * FROM brewies;


-- SECTION A: PROFIT ANALYSIS


SELECT SUM(profit) AS total_profit_made FROM brewies; --(1) ANSWER = 105587420

SELECT DISTINCT
	(SELECT SUM(profit) AS total_anglophone_profit FROM brewies WHERE countries in ('Nigeria','Ghana')),
	(SELECT SUM(profit) AS total_francophone_profit FROM brewies WHERE not countries in ('Nigeria','Ghana'))
FROM brewies;--(2) ANSWER = ANGLOPHONE=42,389,260 FRANCOPHONE=63,198,160

SELECT 
	countries,
	SUM(profit) AS total_profit_made
FROM brewies WHERE years=2019 GROUP BY countries ORDER BY total_profit_made DESC LIMIT 1; --(3) ANSWER= GHANA

SELECT years, SUM(profit) AS total FROM brewies GROUP BY years ORDER BY total DESC LIMIT 1; --(4) ANSWER= 2017

SELECT months, SUM(profit) AS total FROM brewies GROUP BY months ORDER BY total limit 1; --(5) ANSWER = APRIL

SELECT MIN(profit) FROM brewies WHERE months='December' AND years=2019; --(6) ANSWER = 35,300

SELECT SUM(profit) FROM brewies WHERE years=2019; --TOTAL PROFIT MADE IN 2019 = 30020250
SELECT months, (SUM(profit)*1.0/30020250)*100 AS percentage FROM brewies WHERE years=2019 GROUP BY months; --(7)

SELECT brands, SUM(profit) FROM brewies WHERE countries='Senegal' GROUP BY brands ORDER BY SUM(profit) DESC LIMIT 1;--(8) ANSWER= castle lite

-- SECTION B: BRAND ANALYSIS


SELECT 
	brands,
	SUM(quantity) AS quantity_consumed FROM brewies WHERE
	countries IN ('Benin','Senegal','Togo') AND
	years IN (2017,2018) GROUP by brands ORDER BY quantity_consumed DESC LIMIT 3; --(1) ANSWER = BETA MALT, HERO, BUDWEISER
	
SELECT brands, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	countries='Ghana' GROUP BY brands ORDER BY quantity_consumed DESC LIMIT 2; --(2) ANSWER = EAGLE LAGER, CASTLE LITE
	
SELECT 
	brands, 
	SUM(quantity) AS quantity_consumed, 
	SUM(plant_cost) AS total_plant_cost,
	SUM(cost) AS total_cost, 
	SUM(profit) AS total_profit_made
FROM brewies WHERE brands NOT LIKE '% malt' AND countries = 'Nigeria' GROUP BY brands ORDER BY total_profit_made DESC; --(3)

SELECT brands, 
	SUM(quantity) AS quantity_consumed FROM brewies WHERE
	brands LIKE '% malt' AND
	countries IN ('Nigeria','Ghana') AND
	years IN (2018,2019) GROUP BY brands ORDER BY quantity_consumed DESC LIMIT 1; --(4) ANSWER = GRAND MALT

SELECT brands, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	countries='Nigeria' AND years=2019 GROUP BY brands ORDER BY quantity_consumed DESC LIMIT 1;	--(5) ANSWER = HERO
	
SELECT brands, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	countries='Nigeria' AND region='southsouth' GROUP BY brands ORDER BY quantity_consumed DESC LIMIT 1; --(6) ANSWER = EAGLE LAGER
	
SELECT SUM(quantity) AS quantity_consumed FROM brewies WHERE brands NOT LIKE '% malt' AND countries = 'Nigeria'; --(7) ANSWER = 129,260

SELECT region, brands, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	brands='budweiser' GROUP BY region, brands ORDER BY quantity_consumed DESC; --(8)

SELECT region, brands, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	brands='budweiser' AND years=2019 GROUP BY region, brands ORDER BY quantity_consumed DESC; --(9)

-- SECTION C: COUNTRIES ANALYSIS


SELECT countries,  SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	brands NOT LIKE '% malt' GROUP BY countries ORDER BY quantity_consumed DESC LIMIT 1; --(1) ANSWER = SENEGAL
	
SELECT sales_rep, SUM(quantity) AS quantity_consumed FROM brewies WHERE 
	brands='budweiser' AND countries='Senegal' GROUP BY sales_rep ORDER BY quantity_consumed DESC LIMIT 1; --(2) ANSWER = Jones
	
SELECT countries, SUM(profit) AS total_profit FROM brewies WHERE 
	months IN ('September','October','November','December') AND 
	years=2019 GROUP BY countries ORDER BY total_profit DESC LIMIT 1; --(3) ANSWER = GHANA
