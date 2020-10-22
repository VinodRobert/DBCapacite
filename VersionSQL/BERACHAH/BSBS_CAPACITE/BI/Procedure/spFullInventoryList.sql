/****** Object:  Procedure [BI].[spFullInventoryList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [BI].[spFullInventoryList] 
AS

 

CREATE TABLE #STOCKCODES (STKCODE  VARCHAR(15) )

INSERT INTO #STOCKCODES
SELECT DISTINCT STKCODE FROM INVENTORY WHERE LEFT(STKSTORE,3)='FWK' 

INSERT INTO #STOCKCODES 
SELECT DISTINCT STKCODE FROM INVENTORY WHERE LEFT(STKSTORE,4)='MS-9' 

INSERT INTO #STOCKCODES 
SELECT DISTINCT STKCODE FROM INVENTORY WHERE LEFT(STKSTORE,4) ='SE-9' 

SELECT DISTINCT STKCODE INTO #FILTEREDSTOCK FROM #STOCKCODES 
  

ALTER TABLE #FILTEREDSTOCK ADD STKDESC VARCHAR(255)

UPDATE #FILTEREDSTOCK SET STKDESC = I.STKDESC FROM INVENTORY  I INNER JOIN #FILTEREDSTOCK S ON S.STKCODE = I.STKCODE 

SELECT STKCODE,STKDESC  FROM #FILTEREDSTOCK ORDER BY STKDESC 