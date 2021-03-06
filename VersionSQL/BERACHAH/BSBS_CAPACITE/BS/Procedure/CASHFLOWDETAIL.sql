/****** Object:  Procedure [BS].[CASHFLOWDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.CASHFLOWDETAIL(@BORGID INT,@FINYEAR INT,@STARTPERIOD INT,@ENDPERIOD INT)
AS

SELECT 
  COLINDEX AS FLOWID,
  INDEXCODE,
  DESCRIPTION ,
  POSTIONINDEX POSITION
INTO #TEMP0
FROM BS.CASHFLOWINDICATORS
WHERE INDEXCODE > 999

SELECT 
 COLKEY LEDGERCODE,
 VALUE  
INTO #TEMP1
FROM ATTRIBVALUE 
WHERE TABLENAME='LEDGERCODES' AND ATTRIBUTE='Cash Flow Markers'  

SELECT #TEMP0.FLOWID,#TEMP0.POSITION,#TEMP0.INDEXCODE,#TEMP0.DESCRIPTION,#TEMP1.LEDGERCODE 
INTO #TEMP2
FROM #TEMP0,#TEMP1 
WHERE #TEMP1.VALUE = #TEMP0.INDEXCODE 
ORDER BY FLOWID,POSITION 

ALTER TABLE #TEMP2 ADD LEDGERNAME VARCHAR(100)
ALTER TABLE #TEMP2 ADD AMOUNT MONEY 

UPDATE #TEMP2 SET LEDGERNAME = L.LEDGERNAME FROM LEDGERCODES L INNER JOIN #TEMP2 ON #TEMP2.LEDGERCODE = L.LEDGERCODE
SELECT * FROM #TEMP2 

SELECT LEDGERCODE,SUM(DEBIT-CREDIT) LEDGERAMOUNT 
INTO #TEMP3
FROM TRANSACTIONS 
WHERE LEDGERCODE IN (SELECT LEDGERCODE FROM #TEMP2) 
GROUP BY LEDGERCODE 

UPDATE #TEMP2 
SET AMOUNT = T.LEDGERAMOUNT FROM #TEMP3 T
INNER JOIN #TEMP2 ON #TEMP2.LEDGERCODE = T.LEDGERCODE 

SELECT * FROM #TEMP2 