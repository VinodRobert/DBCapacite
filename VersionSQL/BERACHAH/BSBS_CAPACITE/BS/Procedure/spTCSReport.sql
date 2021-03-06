/****** Object:  Procedure [BS].[spTCSReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE BS.spTCSReport(@FINYEAR INT,@STARTPERIOD INT,@ENDPERIOD INT)
AS


SELECT 
 YEAR,
 PERIOD,
 PDATE,
 ORGID,
 BATCHREF,
 TRANSREF,
 CREDNO,
 DEBIT,
 CREDIT
INTO 
 #TEMP0
FROM 
 TRANSACTIONS 
WHERE
 LEDGERCODE  = '1310006'
 AND YEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD

ALTER TABLE #TEMP0 ADD ORGNAME VARCHAR(250)
ALTER TABLE #TEMP0 ADD PAN VARCHAR(15)

UPDATE #TEMP0 SET ORGNAME =B.BORGNAME FROM BORGS B INNER JOIN #TEMP0 ON #TEMP0.ORGID=B.BORGID 
UPDATE #TEMP0 SET PAN = D.PAN FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.CREDNO=D.DEBTNUMBER

ALTER TABLE #TEMP0 ADD STARTPERIOD VARCHAR(25)
ALTER TABLE #TEMP0 ADD ENDPERIOD VARCHAR(25)

ALTER TABLE #TEMP0 ADD PERIODNAME VARCHAR(25)
ALTER TABLE #TEMP0 ADD PARTYNAME VARCHAR(200)

 
UPDATE #TEMP0 SET STARTPERIOD = PS.DESCR FROM PERIODSETUP PS WHERE PS.PERIOD=@STARTPERIOD AND  PS.YEAR=@FINYEAR  
UPDATE #TEMP0 SET ENDPERIOD = PS.DESCR FROM PERIODSETUP PS WHERE PS.PERIOD=@ENDPERIOD AND PS.YEAR=@FINYEAR  

UPDATE #TEMP0 SET PERIODNAME = PS.DESCR FROM PERIODSETUP PS WHERE PS.PERIOD=#TEMP0.PERIOD AND PS.YEAR=@FINYEAR
UPDATE #TEMP0 SET PARTYNAME = D.DEBTNAME FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.CREDNO=D.DEBTNUMBER 



DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
	

SET @FILENAME = 'BSBS_TEMP.DBO.TCS' 


DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
 
SET @Lower = 1 ---- The lowest random number
SET @Upper = 99999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )*1000) + STR(@RANDOM) 

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(6),@FILEID)))

SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0  ORDER BY PERIOD,ORGID  '
SELECT @FILENAME
EXEC(@SQL)
RETURN @FILEID
 
 


 