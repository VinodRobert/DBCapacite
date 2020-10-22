/****** Object:  Procedure [BS].[spGenerateWHTNotBooked]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spGenerateWHTNotBooked](@LEDGERCODE VARCHAR(10), @YEAR INT )
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
SET @FILENAME = 'BSBS_TEMP.DBO.WHTDETAILS'

CREATE TABLE #TEMP0 
(
 TRANGRP    INT,
 ORGID      INT,
 ORGNAME    VARCHAR(150),
 TRANSTYPE  VARCHAR(10),
 PERIOD     INT,
 PDATE      DATETIME,
 BATCHREF   VARCHAR(10),
 TRANSREF   VARCHAR(10),
 REVTYPE    VARCHAR(10),
 CREDNO     VARCHAR(10),
 CREDNAME   VARCHAR(150),
 BASEAMOUNT DECIMAL(18,2),
 WHTAMOUNT  DECIMAL(18,2)
)

DECLARE @CREDITORS VARCHAR(10)
DECLARE @SUBBIE    VARCHAR(10)
DECLARE @WHTCODE   VARCHAR(10)
SELECT @CREDITORS = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
SELECT @SUBBIE    = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
SELECT @WHTCODE   = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors Withholding Tax'

INSERT INTO #TEMP0 (TRANGRP) 
SELECT DISTINCT TRANGRP  FROM TRANSACTIONS WHERE YEAR=@YEAR AND LEDGERCODE = @LEDGERCODE AND CREDNO <>'' 

UPDATE #TEMP0 
SET 
  ORGID = T.ORGID,
  TRANSTYPE  = LEFT(T.BATCHREF,3),
  PERIOD = T.PERIOD,
  PDATE  = T.PDATE,
  BATCHREF = T.BATCHREF,
  TRANSREF = T.TRANSREF,
  REVTYPE = T.TRANSTYPE,
  CREDNO = T.CREDNO ,
  BASEAMOUNT = (T.CREDIT-T.DEBIT) ,
  WHTAMOUNT = 0
FROM 
  TRANSACTIONS T 
INNER JOIN  #TEMP0 ON T.TRANGRP = #TEMP0.TRANGRP AND LEDGERCODE IN (@CREDITORS,@SUBBIE) 

DELETE FROM #TEMP0 WHERE ORGID IS NULL 

UPDATE #TEMP0 
SET
 WHTAMOUNT = (T.CREDIT-T.DEBIT) 
FROM 
 TRANSACTIONS T
INNER JOIN #TEMP0 ON T.TRANGRP = #TEMP0.TRANGRP AND LEDGERCODE = @WHTCODE 

UPDATE #TEMP0 
SET
 ORGNAME = B.BORGNAME 
FROM 
 BORGS B
INNER JOIN #TEMP0 ON ORGID = B.BORGID 

UPDATE #TEMP0 
SET 
 CREDNAME = C.CREDNAME 
FROM 
 CREDITORS C 
INNER JOIN #TEMP0 ON CREDNO = C.CREDNUMBER

UPDATE #TEMP0 
SET 
 CREDNAME = S.SUBNAME 
FROM 
 SUBCONTRACTORS S
INNER JOIN #TEMP0 ON CREDNO =S.SUBNUMBER 

DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
 
SET @Lower = 1 ---- The lowest random number
SET @Upper = 999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )*1000) + STR(@RANDOM) 

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(6),@FILEID)))
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0  ORDER BY ORGID,PERIOD,CREDNO   '
EXEC(@SQL)

SELECT @FILENAME 
RETURN @FILEID
 
 




 


 