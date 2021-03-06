/****** Object:  Procedure [BS].[spSubContractorWorkOrderSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE  [BS].[spSubContractorWorkOrderSummary](@SUBNUMBER VARCHAR(15),@ZONE INT)
AS
DECLARE @SUBID INT 
DECLARE @SUBNAME VARCHAR(50)

SELECT @SUBID=SUBID , @SUBNAME=SUBNAME FROM SUBCONTRACTORS WHERE SUBNUMBER=@SUBNUMBER 

--SELECT * FROM SUBCRECONS 
 
SELECT ORGID,RECONID,ORDERNO INTO #TEMP0  
FROM SUBCRECONS WHERE SUBCONNUMBER=@SUBID AND 
ORGID IN ( SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONE )  


ALTER TABLE #TEMP0 ADD HEADERID INT 
ALTER TABLE #TEMP0 ADD ORDERDATE DATETIME 

UPDATE #TEMP0 SET ORDERDATE = ORD.CREATEDATE FROM ORD INNER JOIN #TEMP0 ON #TEMP0.ORDERNO=ORD.ORDNUMBER

UPDATE #TEMP0 SET HEADERID = H.HEADERID FROM ACCBOQHEADER H  INNER JOIN #TEMP0  ON H.RECONID=#TEMP0.RECONID 
 
SELECT DETAILID,HEADERID,DESCRIPTION,UNIT,QUANTITY,[prog QTY]  PROGQTY ,[prev Qty] ReconQty, (quantity -[prog QTY] ) BALANCE  ,RATE  
INTO #TEMPD
FROM ACCBOQDETAIL WHERE   HEADERID IN (SELECT HEADERID FROM #TEMP0) AND RECONHISTID=-1

--select * from #tempD
DELETE FROM #TEMPD WHERE DESCRIPTION LIKE 'Scheduled Items%' 
 
SELECT @SUBNUMBER SUBNUMBER,T.ORGID,T.ORDERNO,T.ORDERDATE,D.DESCRIPTION,D.QUANTITY,D.PROGQTY,D.ReconQty, D.BALANCE,D.UNIT ,D.RATE 
INTO #FINAL 
FROM #TEMP0 T INNER JOIN  #TEMPD D ON T.HEADERID = D.HeaderId  

ALTER TABLE #FINAL ADD SUBNAME VARCHAR(200)
ALTER TABLE #FINAL ADD ORGNAME VARCHAR(200)

UPDATE #FINAL SET SUBNAME = S.SUBNAME FROM SUBCONTRACTORS S INNER JOIN #FINAL ON #FINAL.SUBNUMBER = S.SUBNUMBER 
UPDATE #FINAL SET ORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #FINAL ON #FINAL.ORGID = B.BORGID 

--DELETE FROM #FINAL WHERE BALANCE=0
DELETE FROM #FINAL WHERE ORDERDATE<'01-APR-2018' 



DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
DECLARE @WIP      VARCHAR(10)

SET @FILENAME = 'BSBS_TEMP.DBO.SUBBIEWO' 

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
SET @SQL = 'SELECT SUBNUMBER,SUBNAME,ORGID,ORGNAME,ORDERNO,ORDERDATE,DESCRIPTION,QUANTITY,UNIT,PROGQTY,RECONQTY,BALANCE,RATE, (BALANCE*RATE) BALANCEAMOUNT  INTO '+@FILENAME+ '  FROM   #FINAL  ORDER BY ORGNAME    '
EXEC(@SQL)
SELECT @FILENAME 
RETURN @FILEID
 