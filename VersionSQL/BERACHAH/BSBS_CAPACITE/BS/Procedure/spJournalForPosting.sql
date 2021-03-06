/****** Object:  Procedure [BS].[spJournalForPosting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spJournalForPosting 
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
SET @FILENAME = 'BSBS_TEMP.DBO.UNPOSTED'

SELECT 
 J.BORGID,
 B.BORGNAME,
 J.JNLPERIOD,
 J.JNLHEADDATE,
 J.JNLHEADTRANSREF,
 J.JNLUSERNAME,
 J.JNLHEADDESCRIPTION
INTO #TEMP0
FROM
 JOURNALHEADER J
INNER JOIN BORGS B ON J.BORGID=B.BORGID 
WHERE JNLHEADPOSTED=0 AND JNLHEADSUBMIT = 1 AND ARCHIVE = 0
ORDER BY BORGID,JNLUSERNAME,JNLHEADDATE 

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
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0  ORDER BY BORGID,JNLUSERNAME,JNLHEADDATE   '
EXEC(@SQL)

SELECT @FILENAME 
RETURN @FILEID