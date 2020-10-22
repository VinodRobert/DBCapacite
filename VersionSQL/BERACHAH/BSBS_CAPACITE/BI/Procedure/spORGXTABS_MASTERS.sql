/****** Object:  Procedure [BI].[spORGXTABS_MASTERS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spORGXTABS_MASTERS](@FINYEAR INT,@REPORTTYPE INT,@FROMPERIOD INT,@TOPERIOD INT,
@LISTLEDGERIDS  LISTLEDGERIDS  READONLY,@LISTORGIDS  LISTORGIDS READONLY )
AS

DECLARE @MASTERLEDGERCODE_FROM  VARCHAR(10)
DECLARE @MASTERLEDGERCODE_TO  VARCHAR(10)
IF @REPORTTYPE=3  
 BEGIN
  SELECT @MASTERLEDGERCODE_FROM = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
  SELECT @MASTERLEDGERCODE_TO   = CONTROLTOGL   FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
 END

IF @REPORTTYPE=4  
 BEGIN
  SELECT @MASTERLEDGERCODE_FROM = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
  SELECT @MASTERLEDGERCODE_TO   = CONTROLTOGL   FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
 END

IF @REPORTTYPE=5  
 BEGIN
  SELECT @MASTERLEDGERCODE_FROM = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Debtors'
  SELECT @MASTERLEDGERCODE_TO   = CONTROLTOGL   FROM CONTROLCODES WHERE CONTROLNAME='Debtors' 
 END

 
 




CREATE TABLE #BORGS(BORGID INT)
INSERT INTO #BORGS 
SELECT ORGID  FROM @LISTORGIDS
DELETE FROM #BORGS WHERE BORGID IS NULL


 


-- EXTRACT TOTAL TRANSACTION DUMP TO TABLE #DUMP 
SELECT 
  T.[YEAR] YEAR,
  T.PERIOD,
  T.ORGID,
  T.CREDNO,
  T.CURRENCY,
  T.HOMECURRAMOUNT,
  T.DEBIT,
  T.CREDIT 
INTO 
  #DUMP 
FROM 
  TRANSACTIONS T 
WHERE 
   T.YEAR=@FINYEAR AND 
   T.PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD  AND 
   T.LEDGERCODE BETWEEN  @MASTERLEDGERCODE_FROM AND @MASTERLEDGERCODE_TO AND 
   T.ORGID IN (SELECT BORGID FROM #BORGS)


-- TO UPDATE THE FOREIGN CURRENCY TRANSACTIONS 
ALTER TABLE #DUMP ADD NETAMOUNT DECIMAL(18,2) 
UPDATE #DUMP SET NETAMOUNT = (DEBIT-CREDIT) WHERE CURRENCY = 'INR'
UPDATE #DUMP SET NETAMOUNT = HomeCurrAmount WHERE CURRENCY <> 'INR' AND DEBIT>0
UPDATE #DUMP SET NETAMOUNT = -1.0*HOMECURRAMOUNT WHERE CURRENCY <>'INR' AND CREDIT>0 


-- FROM THE DUMP CREATE A TEMPORARY TABLE GROUP BY ORGID AND LEDGERCODE 
SELECT 
   D.ORGID,
   D.CREDNO,
   SUM(D.NETAMOUNT) AMOUNT
 INTO 
   #TEMPFINAL 
 FROM 
   #DUMP D
 GROUP BY
   D.ORGID,D.CREDNO  


 


-- TO COME AS LAST ROW WHICH IS THE ORG WISE TOTAL 
SELECT 
  ORGID,
  SUM(AMOUNT) ORGTOTAL
INTO
  #ORGWISETOTAL 
FROM 
  #TEMPFINAL 
GROUP BY
  ORGID 
UPDATE #ORGWISETOTAL SET ORGTOTAL = 0 WHERE ORGTOTAL IS NULL 

-- TO GENERATE THE LAST COLUMN WHICH IS NOTHING BUT LEDGERWISE TOTAL 
SELECT 
  CREDNO,
  SUM(AMOUNT) LEDGERTOTAL 
INTO 
  #LEDGERWISETOTAL
FROM 
  #TEMPFINAL 
GROUP  BY
  CREDNO 
UPDATE #LEDGERWISETOTAL SET LEDGERTOTAL = 0 WHERE LEDGERTOTAL IS NULL 

DECLARE @INTERSECTTOTAL DECIMAL(18,2)
SELECT @INTERSECTTOTAL = SUM(ORGTOTAL) FROM #ORGWISETOTAL

INSERT INTO #TEMPFINAL(ORGID,CREDNO,AMOUNT) 
SELECT ORGID ,'999999', ORGTOTAL FROM #ORGWISETOTAL 
--LAST ROW 


INSERT INTO #TEMPFINAL(ORGID,CREDNO,AMOUNT)
SELECT 999999,CREDNO,LEDGERTOTAL FROM #LEDGERWISETOTAL 
-- LAST COLUMN 


-- LAST RIGHT CORNER (INTERSECT COLUMN) VALUE 

INSERT INTO #TEMPFINAL(ORGID,CREDNO,AMOUNT)
SELECT 999999,999999,@INTERSECTTOTAL

 

ALTER TABLE #TEMPFINAL ADD BORGNAME VARCHAR(6)
ALTER TABLE #TEMPFINAL ADD CREDNAME VARCHAR(150)
 
-- 
UPDATE #TEMPFINAL SET BORGNAME =LEFT(BORGS.BORGNAME,6) FROM BORGS INNER JOIN #TEMPFINAL ON #TEMPFINAL.ORGID=BORGS.BORGID 
UPDATE #TEMPFINAL SET BORGNAME = '999999' WHERE ORGID = 999999
UPDATE #TEMPFINAL SET CREDNAME = LTRIM(RTRIM(#TEMPFINAL.CREDNO))+'-'+LTRIM(RTRIM(LEFT(CREDITORS.CREDNAME,130)))
 FROM CREDITORS INNER JOIN #TEMPFINAL ON #TEMPFINAL.CREDNO=CREDITORS.CREDNUMBER
UPDATE #TEMPFINAL SET CREDNAME = LTRIM(RTRIM(#TEMPFINAL.CREDNO))+'-'+LTRIM(RTRIM(LEFT(SUBCONTRACTORS.SUBNAME,130)))
 FROM SUBCONTRACTORS INNER JOIN #TEMPFINAL ON #TEMPFINAL.CREDNO=SUBCONTRACTORS.SUBNUMBER
UPDATE #TEMPFINAL SET CREDNAME = LTRIM(RTRIM(#TEMPFINAL.CREDNO))+'-'+LTRIM(RTRIM(LEFT(DEBTORS.DEBTNAME,130)))
 FROM DEBTORS INNER JOIN #TEMPFINAL ON #TEMPFINAL.CREDNO=DEBTORS.DEBTNUMBER

UPDATE #TEMPFINAL SET CREDNAME = '999999-TOTAL' WHERE CREDNO='999999'
 

UPDATE #TEMPFINAL SET CREDNAME=UPPER(CREDNAME) 



SELECT ORGID,BORGNAME,CREDNAME,AMOUNT   INTO #FINAL FROM #TEMPFINAL 
 
  


Exec [BI].[CrossTab_ForMASTERS] 'SELECT  CREDNAME,BORGNAME,AMOUNT FROM #FINAL ', 'BORGNAME','SUM(AMOUNT ELSE 0)[]','CREDNAME'

 

 