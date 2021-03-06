/****** Object:  Procedure [BI].[LEDGERAMOUNTWITHSUBLEDGER]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[LEDGERAMOUNTWITHSUBLEDGER](@LISTORGIDS   LISTORGIDS READONLY, @GROUPLEDGERCODE INT ,@FINYEAR INT, @CYFP INT, @CYTP INT )
AS

DECLARE @LEDGERCODE VARCHAR(10)
SELECT LEDGERCODE INTO #LEDGERCODES FROM BI.GROUPLEDGERDETAIL WHERE GROUPLEDGERCODE = @GROUPLEDGERCODE 

CREATE TABLE #BORGS(ORGID INT)
INSERT INTO #BORGS 
SELECT ORGID  FROM @LISTORGIDS
DELETE FROM #BORGS WHERE ORGID IS NULL

CREATE TABLE #REPORTSUBBIEWISE
(
    LEDGERCODE VARCHAR(10),
	LEDGERNAME VARCHAR(100),
	CREDNO VARCHAR(10),
	SUBCONTRACTOR  VARCHAR(100),
	ORGID INT,
	PROJECTNAME VARCHAR(200),
	APRIL DECIMAL(18,2),
	MAY   DECIMAL(18,2),
	JUNE  DECIMAL(18,2),
	JULY  DECIMAL(18,2),
	AUGUST DECIMAL(18,2),
	SEPTEMBER DECIMAL(18,2),
	OCTOBER   DECIMAL(18,2),
	NOVEMBER  DECIMAL(18,2),
	DECEMBER  DECIMAL(18,2),
	JANUARY   DECIMAL(18,2),
	FEBRUARY  DECIMAL(18,2),
	MARCH     DECIMAL(18,2),
	TOTAL     DECIMAL(18,2) 
)


  

SELECT ORGID,CREDNO,PERIOD,LEDGERCODE,SUM(DEBIT-CREDIT) AMOUNT 
INTO #SUBBIEWISE
FROM TRANSACTIONS 
WHERE YEAR=@FINYEAR AND
	    ORGID IN (  SELECT ORGID FROM #BORGS ) AND 
		LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERCODES)    AND
        PERIOD BETWEEN  @CYFP  AND @CYTP
        GROUP BY ORGID, CREDNO,PERIOD ,LEDGERCODE  
  
UPDATE #SUBBIEWISE SET CREDNO='ZZZZZZZZZZ' WHERE CREDNO=''


ALTER TABLE #SUBBIEWISE ADD CREDNAME VARCHAR(150)
ALTER TABLE #SUBBIEWISE ADD PERIODNAME VARCHAR(25)
ALTER TABLE #SUBBIEWISE ADD PROJECTNAME VARCHAR(100) 
ALTER TABLE #SUBBIEWISE ADD LEDGERNAME VARCHAR(100)

UPDATE #SUBBIEWISE SET PROJECTNAME = B.BORGNAME FROM BORGS B INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.ORGID = B.BORGID 
UPDATE #SUBBIEWISE SET CREDNAME = S.SUBNAME FROM SUBCONTRACTORS S INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.CREDNO=S.SUBNUMBER 
UPDATE #SUBBIEWISE SET CREDNAME = D.DEBTNAME FROM DEBTORS D INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.CREDNO= D.DEBTNUMBER
UPDATE #SUBBIEWISE SET CREDNAME = C.CREDNAME FROM CREDITORS C INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.CREDNO=C.CREDNUMBER 
UPDATE #SUBBIEWISE SET PERIODNAME = P.PERIODDESC FROM PERIODMASTER P INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.PERIOD = P.PERIODID 
UPDATE #SUBBIEWISE SET CREDNAME = 'ZZZZZ [NO SUPPLIER]' WHERE CREDNO='ZZZZZZZZZZ'
UPDATE #SUBBIEWISE SET LEDGERNAME = L.LEDGERNAME FROM LEDGERCODES L INNER JOIN #SUBBIEWISE ON #SUBBIEWISE.LEDGERCODE=L.LEDGERCODE 
 
INSERT INTO #REPORTSUBBIEWISE(LEDGERCODE,LEDGERNAME,CREDNO,SUBCONTRACTOR,ORGID,PROJECTNAME)
SELECT DISTINCT LEDGERCODE,LEDGERNAME, CREDNO, CREDNAME, ORGID,  RTRIM(PROJECTNAME)   FROM #SUBBIEWISE
UPDATE #REPORTSUBBIEWISE SET APRIL = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID  WHERE   #SUBBIEWISE.PERIOD=1 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET MAY = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND  #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE   #SUBBIEWISE.PERIOD=2 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET JUNE = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=3 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET JULY = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE   #SUBBIEWISE.PERIOD=4 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET AUGUST = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE   #SUBBIEWISE.PERIOD=5 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET SEPTEMBER = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE   #SUBBIEWISE.PERIOD=6 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET OCTOBER = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=7 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET NOVEMBER = AMOUNT FROM  #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE   #SUBBIEWISE.PERIOD=8 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET DECEMBER = AMOUNT FROM  #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=9 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET JANUARY = AMOUNT FROM   #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=10 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET FEBRUARY = AMOUNT FROM  #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=11 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
UPDATE #REPORTSUBBIEWISE SET MARCH = AMOUNT FROM #SUBBIEWISE INNER JOIN #REPORTSUBBIEWISE ON #REPORTSUBBIEWISE.CREDNO=#SUBBIEWISE.CREDNO 
 AND #REPORTSUBBIEWISE.ORGID=#SUBBIEWISE.ORGID WHERE  #SUBBIEWISE.PERIOD=12 AND #SUBBIEWISE.LedgerCode = #REPORTSUBBIEWISE.LEDGERCODE 
   


UPDATE #REPORTSUBBIEWISE SET APRIL = 0 WHERE APRIL IS NULL
UPDATE #REPORTSUBBIEWISE SET MAY = 0 WHERE MAY IS NULL
UPDATE #REPORTSUBBIEWISE SET JUNE = 0 WHERE JUNE IS NULL
UPDATE #REPORTSUBBIEWISE SET JULY = 0 WHERE JULY IS NULL
UPDATE #REPORTSUBBIEWISE SET AUGUST = 0 WHERE AUGUST IS NULL
UPDATE #REPORTSUBBIEWISE SET SEPTEMBER = 0 WHERE SEPTEMBER IS NULL
UPDATE #REPORTSUBBIEWISE SET OCTOBER = 0 WHERE OCTOBER IS NULL
UPDATE #REPORTSUBBIEWISE SET NOVEMBER = 0 WHERE NOVEMBER IS NULL
UPDATE #REPORTSUBBIEWISE SET DECEMBER = 0 WHERE DECEMBER IS NULL
UPDATE #REPORTSUBBIEWISE SET JANUARY = 0 WHERE JANUARY IS NULL
UPDATE #REPORTSUBBIEWISE SET FEBRUARY = 0 WHERE FEBRUARY IS NULL
UPDATE #REPORTSUBBIEWISE SET MARCH = 0 WHERE MARCH IS NULL

UPDATE #REPORTSUBBIEWISE SET TOTAL = APRIL+MAY+JUNE+JULY+AUGUST+SEPTEMBER+OCTOBER+NOVEMBER+DECEMBER+JANUARY+FEBRUARY+MARCH
 
SELECT * FROM #REPORTSUBBIEWISE ORDER BY LEDGERCODE,CREDNO,PROJECTNAME 