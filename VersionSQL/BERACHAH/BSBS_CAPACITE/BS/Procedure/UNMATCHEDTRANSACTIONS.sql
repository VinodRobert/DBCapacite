/****** Object:  Procedure [BS].[UNMATCHEDTRANSACTIONS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[UNMATCHEDTRANSACTIONS](@LISTORGIDS  LISTORGIDS READONLY, @FINYEAR INT ,@PERIODTO INT,@PARTYID  INT )
AS

DECLARE @CONTROLCODE VARCHAR(15)

CREATE TABLE #TEMP0(TRANGRP INT,TRANSID INT,ORGID INT,BORGNAME VARCHAR(200),PARTYCODE VARCHAR(15),PARTYNAME VARCHAR(200),YEAR INT, PERIOD INT,PDATE DATETIME,
BATCHREF VARCHAR(10),TRANSREF VARCHAR(10),TRANSTYPE VARCHAR(15),LEDGERCODE VARCHAR(15),DESCRIPTION VARCHAR(255),DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),
CURRENCY VARCHAR(15),HOMECURRAMOUNT DECIMAL(18,2)) 

IF @PARTYID = 1
   SELECT @CONTROLCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
ELSE
   SELECT @CONTROLCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'

CREATE TABLE #BORGS(ORGID INT)
INSERT INTO #BORGS 
SELECT ORGID  FROM @LISTORGIDS
DELETE FROM #BORGS WHERE ORGID IS NULL

DELETE FROM #TEMP0 
INSERT INTO #TEMP0 
SELECT 
 T.TRANGRP,
 T.TRANSID,
 T.ORGID,
 B.BORGNAME,
 T.CREDNO,
 '' ,
 T.YEAR,
 T.PERIOD,
 T.PDATE,
 T.BATCHREF,
 T.TRANSREF,
 T.TRANSTYPE,
 T.LEDGERCODE,
 T.DESCRIPTION,
 T.DEBIT,
 T.CREDIT,
 T.CURRENCY,
 T.HOMECURRAMOUNT 
FROM 
 TRANSACTIONS  T
 INNER JOIN BORGS B ON T.ORGID = B.BORGID 
WHERE
 T.PAIDFOR <> 1 AND 
 T.LEDGERCODE=@CONTROLCODE AND
 T.YEAR = @FINYEAR AND 
 T.PERIOD BETWEEN 0 AND  @PERIODTO  AND 
 T.ORGID IN (SELECT ORGID FROM #BORGS)
 

 

IF  @PARTYID = 2
 UPDATE #TEMP0 SET PARTYNAME  = S.SUBNAME FROM SUBCONTRACTORS S INNER JOIN #TEMP0 ON #TEMP0.PARTYCODE  = S.SUBNUMBER 
ELSE
 UPDATE #TEMP0 SET PARTYNAME = C.CREDNAME FROM CREDITORS C INNER JOIN #TEMP0 ON #TEMP0.PARTYCODE = C.CREDNUMBER 

SELECT * FROM #TEMP0 ORDER BY ORGID,PARTYCODE 