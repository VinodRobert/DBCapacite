/****** Object:  Procedure [BS].[spGenerateUnPostedSubbieBills]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spGenerateUnPostedSubbieBills
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)


SET @FILENAME = 'BSBS_TEMP.DBO.UNPOSTEDSUBBIEBILL'

SELECT 
 S.ORGID,
 B.BORGNAME,
 S.SUBCONNUMBER,
 S.SUPNAME,
 S.ACTIVITY,
 A.ACTNAME,
 S.TOTDUE,
 S.CODE,
 S.POSTED,
 S.ORDERNO,
 S.REMARK,
 S.USERID ,
 S.SCAPPDATE
INTO
 #TEMP0
FROM
 SUBCRECONS S 
 INNER JOIN BORGS B ON B.BORGID=S.ORGID
 INNER JOIN ACTIVITIES A ON A.ACTID = S.Activity
WHERE
 S.TOTDUE >0 AND
 S.POSTED=0
 

 
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

SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0 ORDER BY ORGID,SUBCONNUMBER '
 
EXEC(@SQL)

RETURN @FILEID