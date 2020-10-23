/****** Object:  Procedure [BS].[spFetchLedgersForOppositeLegs]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spFetchLedgersForOppositeLegs]
AS
SELECT LEDGERCODE,UPPER(LTRIM(RTRIM(LEDGERNAME))) LEDGERNAME INTO #TEMP0 FROM LEDGERCODES  WHERE LEDGERALLOC IN ('BALANCE SHEET','CONTRACTS') AND LEDGERSUMMARY=0
DELETE FROM #TEMP0 WHERE LEDGERCODE='1315000'
DELETE FROM #TEMP0 WHERE LEDGERCODE='1320000' 
DELETE FROM #TEMP0 WHERE LEDGERCODE='1100015' 
DELETE FROM #TEMP0 WHERE LEDGERCODE='1320000' 
DELETE FROM #TEMP0 WHERE LEDGERCODE='2513000' 
DELETE FROM #TEMP0 WHERE LEDGERCODE='1100005' 
DELETE FROM #TEMP0 WHERE LEDGERCODE='2990000'
DELETE FROM #TEMP0 WHERE LEDGERCODE BETWEEN '2100001'  AND '2101000'
DELETE FROM #TEMP0 WHERE LEDGERCODE BETWEEN '2200001'  AND '2201000'
DELETE FROM #TEMP0 WHERE LEDGERCODE BETWEEN '2540000'  AND '2540005'
--DELETE FROM #TEMP0 WHERE LEDGERCODE BETWEEN '2500000'  AND '2510099'  
--MODIFIED AS PER ASHOK REQUEST 
INSERT INTO #TEMP0(LEDGERCODE,LEDGERNAME) 
VALUES ('2100099','SITE ESTABLISHMENT - ASSET ADDITION')

SELECT * FROM #TEMP0 WHERE LEDGERNAME <>''  ORDER BY LEDGERNAME