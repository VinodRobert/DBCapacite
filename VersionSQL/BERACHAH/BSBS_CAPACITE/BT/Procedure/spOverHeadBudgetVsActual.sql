/****** Object:  Procedure [BT].[spOverHeadBudgetVsActual]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spOverHeadBudgetVsActual](@PROJECTCODE INT,@TOPERIOD INT)
AS

DECLARE @FINYEAR INT 
DECLARE @ENDPERIOD INT 
DECLARE @BORGID INT 
 
SELECT @BORGID = BORGID FROM BT.PROJECTS WHERE PROJECTID=@PROJECTCODE 

SELECT @FINYEAR=FINYEAR , @ENDPERIOD=PERIOD FROM BT.YEARPERIODMASTER WHERE YEARPERIODID = @TOPERIOD 

 

SELECT GLCODE,AMOUNT BUDGET 
INTO #BUDGETS
FROM BT.OVERHEAD 
WHERE PROJECTCODE=@PROJECTCODE 
 

SELECT GLCODE,SUM(AMOUNT) PERIODBUDGET 
INTO #PERIODBUDGET 
FROM BT.OVERHEADSPREAD 
where OVERHEADCODE IN (SELECT OVERHEADID FROM BT.OVERHEAD WHERE PROJECTCODE=@PROJECTCODE) AND 
YEARPERIODCODE <=@TOPERIOD 
GROUP BY GLCODE 

SELECT LEDGERCODE,SUM(DEBIT-CREDIT) ACTUALAMOUNT
INTO #ACTUALS 
FROM TRANSACTIONS 
WHERE  ORGID=@BORGID AND YEAR=@FINYEAR AND PERIOD<=@ENDPERIOD 
GROUP BY LEDGERCODE 

CREATE TABLE #FINAL (GLCODE VARCHAR(15), LEDGERNAME VARCHAR(200), TOTALBUDGET DECIMAL(18,2), 
PERIODBUDGET DECIMAL(18,2), ACTUAL DECIMAL(18,2),VARIANCE DECIMAL(18,2) ) 

INSERT INTO #FINAL (GLCODE,TOTALBUDGET) 
SELECT GLCODE,BUDGET FROM #BUDGETS 


UPDATE #FINAL SET LEDGERNAME = L.LEDGERNAME FROM LEDGERCODES L INNER JOIN #FINAL ON #FINAL.GLCODE = L.LEDGERCODE 

UPDATE #FINAL SET PERIODBUDGET = P.PERIODBUDGET FROM #PERIODBUDGET P INNER JOIN #FINAL ON #FINAL.GLCODE = P.GLCODE 

UPDATE #FINAL SET ACTUAL = A.ACTUALAMOUNT FROM #ACTUALS A INNER JOIN #FINAL ON #FINAL.GLCODE = A.LEDGERCODE 

UPDATE #FINAL SET PERIODBUDGET = 0 WHERE PERIODBUDGET IS NULL 
UPDATE #FINAL SET ACTUAL = 0 WHERE ACTUAL IS NULL 

UPDATE #FINAL SET VARIANCE =   ACTUAL - PERIODBUDGET WHERE ACTUAL >0 

UPDATE #FINAL SET LEDGERNAME = UPPER(LEDGERNAME) 

UPDATE #FINAL SET VARIANCE=0 WHERE VARIANCE IS NULL 


SELECT LEDGERCODE GLCODE,PDATE,BATCHREF,TRANSREF,DESCRIPTION,DEBIT,CREDIT 
INTO #DETAIL 
FROM TRANSACTIONS 
WHERE  ORGID=@BORGID AND YEAR=@FINYEAR AND PERIOD<=@ENDPERIOD 
ORDER BY GLCODE 

DELETE FROM #DETAIL WHERE GLCODE NOT IN (SELECT GLCODE FROM #FINAL) 

SELECT *  FROM #FINAL  ORDER BY GLCODE 
SELECT *  FROM #DETAIL ORDER BY GLCODE 


 