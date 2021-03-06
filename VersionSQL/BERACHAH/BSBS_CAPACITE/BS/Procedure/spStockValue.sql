/****** Object:  Procedure [BS].[spStockValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   PROCEDURE [BS].[spStockValue]
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
DECLARE @ORGID INT

SET @FILENAME = 'BSBS_TEMP.DBO.STOCKVALUE'

SELECT DISTINCT BORGID,STKSTORE INTO #TEMP1  FROM INVENTORY 
DELETE FROM #TEMP1 WHERE BORGID NOT IN (SELECT BORGID FROM BORGS WHERE PARENTBORG IN (23,24,25,26)) 

SELECT I.STKSTORE,S.STORENAME,SUM(I.STKQUANTITY*I.STKCOSTRATE) INVENTORYVALUE 
INTO #TEMP0
FROM INVENTORY I INNER JOIN INVSTORES S ON I.STKSTORE=S.STORECODE 
WHERE LEFT(I.STKSTORE,4)='MS-9'
GROUP BY STKSTORE,STORENAME 
 
ALTER TABLE #TEMP0 ADD BORGID INT
UPDATE #TEMP0 SET BORGID = T.BORGID FROM #TEMP1 T INNER JOIN #TEMP0 ON T.StkStore = #TEMP0.STKSTORE 
DELETE FROM #TEMP0 WHERE BORGID IS NULL 
    
SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
+ (DATEPART(ss, GETDATE()) * 1000 )
+ DATEPART(ms, GETDATE()) )*1000)

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
SELECT @FILENAME 
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0   ORDER BY STORENAME '

EXEC(@SQL)

RETURN @FILEID