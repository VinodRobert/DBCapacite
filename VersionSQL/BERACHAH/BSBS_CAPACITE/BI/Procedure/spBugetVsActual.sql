/****** Object:  Procedure [BI].[spBugetVsActual]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [BI].[spBugetVsActual](@BORGID INT,@FROMYEAR INT,@TOYEAR INT,@FROMPERIOD INT,@TOPERIOD INT)
AS

-- EXTRACT THE ACTUAL VALUES FROM TRANSACTION TABLE FOR THE GIVEN PROJECTS FOR A GIVEN PERIOD FOR A GIVEN YEAR
SELECT ORGID,YEAR,PERIOD,LEDGERCODE,SUM(DEBIT-CREDIT) ACTUAL
INTO #ACTUAL 
FROM TRANSACTIONS 
WHERE
  ORGID = @BORGID AND 
  YEAR BETWEEN @FROMYEAR AND @TOYEAR  AND 
  PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD AND 
  PERIOD <> 0 AND 
  LEDGERCODE IN (SELECT LEDGERCODE FROM LEDGERCODES WHERE LEDGERALLOC='Contracts')  
GROUP BY ORGID,YEAR,PERIOD,LEDGERCODE

-- MERGING THE ACTAUL LEDGERS AND LEDGERS UPLOADED FOR BUDGET TO COMPLETTE COMPLETE LIST OF POSSIBLE LEDGERS 

SELECT DISTINCT LEDGERCODE 
INTO #AVAILABLELEDGERS 
FROM ( SELECT LEDGERCODE FROM #ACTUAL 
       UNION 
	   SELECT LEDGERCODE FROM BI.YEARLYBUDGETS WHERE [FINYEAR] BETWEEN @FROMYEAR AND @TOYEAR  AND  ORGID = @BORGID ) T

-- LEDGERS MAY HAVE BUDGET BUT NOT ACTUAL AND VICE VERSA
CREATE TABLE #TOTALLEDGERCODES ( LEDGERCODE VARCHAR(15) )
INSERT INTO #TOTALLEDGERCODES(LEDGERCODE) 
SELECT LEDGERCODE  FROM #AVAILABLELEDGERS 

-- CREATE A REPOSITORY
CREATE TABLE #BUDGETACTUAL( IDENTIFIER CHAR(1),ORGID INT,FINYEAR INT,PERIOD INT,PERIODNAME VARCHAR(10),LEDGERCODE VARCHAR(15),LEDGERNAME VARCHAR(35),AMOUNT DECIMAL(18,2))

-- EXTRACT BUDGET 
INSERT INTO #BUDGETACTUAL(IDENTIFIER,ORGID,FINYEAR,PERIOD,PERIODNAME,LEDGERCODE,LEDGERNAME,AMOUNT) 
SELECT 'B',ORGID,FINYEAR,PERIOD,SPACE(10),LEDGERCODE,SPACE(35),BUDGET FROM BI.YEARLYBUDGETS 
WHERE ORGID = @BORGID AND 
      FINYEAR BETWEEN @FROMYEAR AND @TOYEAR AND
	  PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD 

-- INSERT ACTUAL 
INSERT INTO #BUDGETACTUAL(IDENTIFIER,ORGID,FINYEAR,PERIOD,PERIODNAME,LEDGERCODE,LEDGERNAME,AMOUNT)
SELECT 'A', ORGID,YEAR,PERIOD,SPACE(10),LEDGERCODE,SPACE(35),ACTUAL FROM #ACTUAL

UPDATE #BUDGETACTUAL SET AMOUNT = 0 WHERE AMOUNT IS NULL 

UPDATE #BUDGETACTUAL SET PERIODNAME = UPPER(LEFT(PERIODDESC,3)) FROM PERIODMASTER INNER JOIN #BUDGETACTUAL ON #BUDGETACTUAL.PERIOD=PERIODMASTER.PERIODID 

UPDATE #BUDGETACTUAL SET LEDGERNAME = UPPER(L.LEDGERNAME) FROM LEDGERCODES L INNER JOIN #BUDGETACTUAL ON #BUDGETACTUAL.LEDGERCODE = L.LEDGERCODE 

--SELECT * INTO VRBA FROM #BUDGETACTUAL 
ALTER TABLE #BUDGETACTUAL ADD NARRATION VARCHAR(15) 
UPDATE #BUDGETACTUAL SET NARRATION = LTRIM(RTRIM(STR(FINYEAR)))+'-'+LTRIM(RTRIM(PERIODNAME))+'-'+IDENTIFIER 

SELECT  LEDGERNAME,NARRATION,AMOUNT FROM #BUDGETACTUAL

--Exec [BI].[CrossTab]  'SELECT  LEDGERNAME,BORGNAME,AMOUNT FROM #FINAL ', 'BORGNAME','SUM(AMOUNT ELSE 0)[]','LEDGERNAME'

Exec [BI].[CrossTab]  'SELECT  LEDGERNAME,NARRATION,AMOUNT FROM #BUDGETACTUAL ', 'NARRATION','SUM(AMOUNT ELSE 0)[]','LEDGERNAME' 


 