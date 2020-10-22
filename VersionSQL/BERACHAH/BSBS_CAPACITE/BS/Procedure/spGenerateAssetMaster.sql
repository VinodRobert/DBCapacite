/****** Object:  Procedure [BS].[spGenerateAssetMaster]    Committed by VersionSQL https://www.versionsql.com ******/

--SELECT * FROM ASSETS where assetnumber='LMV0001004 '
--SELECT ASSETNUMBER,ASSETNAME,ASSETPDATE,ASSETPPRICE,ASSETBOOKVALUE,ASSETACCUMDEP,ASSETOPPCODE,ASSETSALVAGE,ASSETLOCATION,BORGS.BORGNAME ,AssetPeriod,ASSETDEPPROG,AssetfPeriod 
--FROM ASSETS INNER JOIN BORGS ON ASSETS.ASSETLOCATION=LEFT(BORGS.BORGNAME,5) where assetnumber='LMV0001004 '
CREATE PROCEDURE [BS].[spGenerateAssetMaster]
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
SET @FILENAME = 'BSBS_TEMP.DBO.ASSETMASTER'

SELECT 
 ASSETNUMBER,
 ASSETNAME,
 ASSETPDATE,
 ASSETPPRICE,
 ASSETADD,
 ASSETSALE,
 (ASSETPPRICE+ASSETADD-ASSETSALE) ASSETVALUE,
 ASSETSALVAGE,
 AssetAccumDep,
 AssetBookValue,
 ASSETPERIOD TOTALLIFE,
 ASSETDEP  REMAININGLIFE,
 ASSETLOCATION,
 ASSETOPPCODE,
 SPACE(100) CATEGORY,
 SPACE(100) LOCATION 
INTO #TEMP0
FROM ASSETS 
ORDER BY ASSETPDATE  DESC
 

UPDATE #TEMP0 SET CATEGORY =  UPPER(LTRIM(RTRIM(SUBSTRING(LEDGERNAME,12,100)))) FROM LEDGERCODES INNER JOIN #TEMP0 ON LEDGERCODE=#TEMP0.ASSETOPPCODE 
UPDATE #TEMP0 SET LOCATION = UPPER(BORGNAME) FROM BORGS INNER JOIN #TEMP0 ON LEFT(BORGS.BORGNAME,5)=#TEMP0.AssetLocation

 

SELECT ASSETOPPCODE, SUM(ASSETVALUE) FROM #TEMP0 GROUP BY ASSETOPPCODE ORDER BY ASSETOPPCODE 
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
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0  ORDER BY CATEGORY,ASSETPDATE    '
EXEC(@SQL)
SELECT @FILENAME 
RETURN @FILEID