/****** Object:  Procedure [BI].[spOppositeLedgerRegisterAllMasters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spOppositeLedgerRegisterAllMasters] (@FINYEAR INT, @FROMPERIOD INT,@TOPERIOD INT,@LISTORGIDS  LISTORGIDS READONLY,@PARTYCODE VARCHAR(15),@PARTYTYPE INT  )
As
 
DECLARE @RETAINED VARCHAR(10)
DECLARE @WIP VARCHAR(10)
SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Retained Income'
SELECT @WIP = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Work In Progress'
DECLARE @BANKSTART VARCHAR(15)
DECLARE @BANKEND VARCHAR(15)
DECLARE @LEDGERCODE VARCHAR(15)
DECLARE @TGRP INT
DECLARE @CNT DECIMAL(18,5)
DECLARE @NEWTGP DECIMAL(18,2) 

DECLARE @LEDGERCODEFROM VARCHAR(15)
DECLARE @LEDGERCODETO   VARCHAR(15)

SELECT @LEDGERCODEFROM=CONTROLFROMGL, @LEDGERCODETO = CONTROLTOGL FROM CONTROLCODES WHERE CONTROLID = @PARTYTYPE 

 

SELECT @BANKSTART=CONTROLFROMGL ,@BANKEND=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Bank' 


CREATE TABLE #BORGS(ORGID INT)
INSERT INTO #BORGS  
SELECT BORGID FROM BORGS 

DELETE FROM #BORGS WHERE ORGID IS NULL


SELECT 
 DISTINCT T.TRANGRP 
INTO 
 #TRANGROUPS
FROM 
 TRANSACTIONS T
WHERE 
 T.YEAR=@FINYEAR AND 
 T.PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD AND 
 T.LEDGERCODE BETWEEN @LEDGERCODEFROM AND @LEDGERCODETO  AND
 T.CREDNO = @PARTYCODE AND 
 T.ORGID IN (SELECT ORGID FROM #BORGS)



CREATE TABLE #DUMMYTRANS(TRANGRP INT,TRANSID INT,ORGID INT, TRANSTYPE VARCHAR(3),YEAR INT, PERIOD INT,BATCHREF VARCHAR(10),PDATE DATETIME,TRANSREF VARCHAR(10),LEDGERCODE VARCHAR(10),CREDNO VARCHAR(10),
DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),CATEGORY VARCHAR(60) ) 

CREATE TABLE #TEMP0(TRANGRP INT,TRANSID INT,ORGID INT, TRANSTYPE VARCHAR(3),YEAR INT, PERIOD INT,BATCHREF VARCHAR(10),PDATE DATETIME,TRANSREF VARCHAR(10),LEDGERCODE VARCHAR(10),CREDNO VARCHAR(10),
DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),CATEGORY VARCHAR(60) ) 


DECLARE @GROUPID INT 
DECLARE @HOWMANYDEBITS INT 
DECLARE @HOWMANYCREDITS INT 
DECLARE @HOWMANYBORGS INT 
DECLARE @DEBITORGID INT 
DECLARE @CREDITORGID INT

DECLARE TGROUP CURSOR FOR SELECT TRANGRP FROM #TRANGROUPS

OPEN TGROUP 
FETCH NEXT FROM TGROUP INTO @GROUPID

WHILE @@FETCH_STATUS = 0 
BEGIN
  INSERT INTO #DUMMYTRANS 
  SELECT TRANGRP,TRANSID,ORGID,LEFT(TRANSTYPE,3),YEAR,PERIOD,BATCHREF,PDATE,TRANSREF,LEDGERCODE,CREDNO,DEBIT,CREDIT,'' 
  FROM TRANSACTIONS 
  WHERE TRANGRP = @GROUPID 

  DELETE FROM #DUMMYTRANS WHERE LEDGERCODE IN (@WIP,@RETAINED) 

  SET @HOWMANYBORGS=1
  SET @HOWMANYDEBITS=0
  SET @HOWMANYCREDITS=0

  SELECT @HOWMANYBORGS = COUNT(DISTINCT ORGID) FROM #DUMMYTRANS
  IF @HOWMANYBORGS >1 
     UPDATE #DUMMYTRANS SET CATEGORY=CATEGORY+' InterCompany'



  SELECT @HOWMANYDEBITS = COUNT(*) FROM #DUMMYTRANS WHERE LEDGERCODE = @LEDGERCODE AND DEBIT>0 
  IF @HOWMANYDEBITS > 1
     UPDATE #DUMMYTRANS SET CATEGORY=CATEGORY+ ' Multiple Debits'
  
  IF @HOWMANYDEBITS= 1
   BEGIN
     SELECT @DEBITORGID = ORGID FROM #DUMMYTRANS WHERE LEDGERCODE=@LEDGERCODE AND DEBIT>0 
	 UPDATE #DUMMYTRANS SET ORGID=@DEBITORGID 
   END

  SELECT @HOWMANYCREDITS = COUNT(*) FROM #DUMMYTRANS WHERE LEDGERCODE = @LEDGERCODE AND CREDIT>0 
  IF @HOWMANYCREDITS > 1
     UPDATE #DUMMYTRANS SET CATEGORY=CATEGORY+ ' Multiple Credits'
  
  IF @HOWMANYCREDITS= 1
   BEGIN
     SELECT @CREDITORGID  = ORGID FROM #DUMMYTRANS WHERE LEDGERCODE=@LEDGERCODE AND CREDIT>0 
	 UPDATE #DUMMYTRANS SET ORGID=@CREDITORGID 
   END
  
  
  INSERT INTO #TEMP0(TRANGRP,TRANSID,ORGID,TRANSTYPE,YEAR,PERIOD,BATCHREF,PDATE,TRANSREF,LEDGERCODE,CREDNO,DEBIT,CREDIT,CATEGORY) 
  SELECT * FROM #DUMMYTRANS
  
   DELETE FROM #DUMMYTRANS
  FETCH NEXT FROM TGROUP INTO @GROUPID

END
CLOSE TGROUP
DEALLOCATE TGROUP 


ALTER TABLE #TEMP0 ADD BORGNAME VARCHAR(200)
ALTER TABLE #TEMP0 ADD PERIODDESC VARCHAR(50)
ALTER TABLE #TEMP0 ADD SUPPLIERNAME VARCHAR(150)
ALTER TABLE #TEMP0 ADD LEDGERNAME VARCHAR(100)
UPDATE #TEMP0 SET LEDGERNAME = L.LEDGERNAME FROM LEDGERCODES L INNER JOIN #TEMP0 ON #TEMP0.LEDGERCODE =L.LEDGERCODE 
UPDATE #TEMP0 SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TEMP0 ON #TEMP0.ORGID = B.BORGID 
UPDATE #TEMP0 SET PERIODDESC = P.PERIODDESC FROM PERIODMASTER P INNER JOIN #TEMP0 ON #TEMP0.PERIOD = P.PERIODID 
UPDATE #TEMP0 SET SUPPLIERNAME=C.CREDNAME FROM CREDITORS C INNER JOIN #TEMP0 ON #TEMP0.CREDNO=C.CREDNUMBER 
UPDATE #TEMP0 SET SUPPLIERNAME=D.DEBTNAME FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.CREDNO=D.DEBTNUMBER  
UPDATE #TEMP0 SET SUPPLIERNAME=S.SUBNAME FROM SUBCONTRACTORS S INNER JOIN #TEMP0 ON #TEMP0.CREDNO=S.SUBNUMBER 
  
 
DELETE FROM #TEMP0 WHERE BORGNAME='99999 - TEST BUDGET TOOL' 

 



 

 SELECT 
   TRANGRP,
   TRANSID,
   CATEGORY,
   BORGNAME,
   YEAR,
   PERIODDESC,
   PDATE ,
   BATCHREF,
   TRANSREF,
   TRANSTYPE,
   CREDNO,
   SUPPLIERNAME AS PARTYNAME,
   (LTRIM(RTRIM(LEDGERCODE))+'-'+LEFT(LEDGERNAME,25)) AS LEDGERNAME,
   (DEBIT-CREDIT) AMOUNT 
  INTO 
   #FINAL
  FROM 
   #TEMP0
  ORDER BY 
   TRANGRP,TRANSID


UPDATE #FINAL SET LEDGERNAME = LTRIM(RTRIM(LEDGERNAME))

UPDATE #FINAL SET LEDGERNAME = ' '+LEDGERNAME WHERE LEFT(LEDGERNAME,7)=LEFT(@LEDGERCODE,7)

 
--SELECT * FROM #FINAL

Exec [BI].[CrossTab] 'SELECT  TRANGRP,CATEGORY,BORGNAME,YEAR,PERIODDESC,PDATE,BATCHREF,TRANSREF,TRANSTYPE,CREDNO,PARTYNAME,LEDGERNAME,AMOUNT FROM #FINAL', 'LEDGERNAME','SUM(AMOUNT ELSE 0)[]','TRANGRP,CATEGORY,BORGNAME,YEAR,PERIODDESC,PDATE,BATCHREF,TRANSREF,TRANSTYPE,CREDNO,PARTYNAME'