/****** Object:  Procedure [BS].[spStaffDebtorSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BS].[spStaffDebtorSummary](@YEAR INT)
AS
DECLARE @STAFFDEBTOR VARCHAR(10)
SET @STAFFDEBTOR = '2540002'

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
DECLARE @ORGID INT

SET @FILENAME = 'BSBS_TEMP.DBO.STAFFLOAN'


SELECT T.ORGID,B.BORGNAME,T.CREDNO,SUM(DEBIT) DEBIT,SUM(CREDIT) CREDIT 
INTO #TEMP0
FROM 
 TRANSACTIONS T 
 INNER JOIN BORGS B ON T.ORGID = B.BORGID 
 INNER JOIN DEBTORS D ON T.CREDNO  = D.DEBTNUMBER 
WHERE
 T.YEAR=@YEAR AND T.LEDGERCODE=@STAFFDEBTOR
GROUP BY 
 T.CREDNO , T.ORGID,B.BORGNAME
ORDER BY
 T.ORGID 

 select * from #temp0  order by credno   
ALTER TABLE #TEMP0  ADD DEBTNAME VARCHAR(100)
UPDATE #TEMP0 SET DEBTNAME = D.DEBTNAME FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.CREDNO=D.DEBTNUMBER 

ALTER TABLE #TEMP0 ADD FINYEAR CHAR(4)
UPDATE #TEMP0 SET FINYEAR = STR(@YEAR ,4)

SELECT * FROM #TEMP0 WHERE DEBTNAME LIKE 'RAJESH%' 
    
SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
+ (DATEPART(ss, GETDATE()) * 1000 )
+ DATEPART(ms, GETDATE()) )*1000)

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
SELECT @FILENAME 
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0   ORDER BY CREDNO, DEBTNAME,BORGNAME '

EXEC(@SQL)

RETURN @FILEID