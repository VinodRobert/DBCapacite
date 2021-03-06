/****** Object:  Procedure [BS].[spGenerateSubbieAdvance]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spGenerateSubbieAdvance](@ZONEID INT, @BORGID INT,@FINYEAR INT,@CREDNO VARCHAR(10),@SUMMARY INT  )
AS
  
DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
DECLARE @ORGID INT

SET @FILENAME = 'BSBS_TEMP.DBO.SUBBIEADVANCE'

DECLARE @SUBBIEADV  VARCHAR(10)
SET @SUBBIEADV  = '1320003'

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
+ (DATEPART(ss, GETDATE()) * 1000 )
+ DATEPART(ms, GETDATE()) )*1000)

CREATE TABLE #BORGS (BORGID INT)
INSERT INTO #BORGS SELECT BORGID FROM BORGS WHERE PARENTBORG = 5
INSERT INTO #BORGS VALUES (5) 

IF @ZONEID=0  AND @SUMMARY = 0  
 BEGIN
 -- Sinlge Subbie within an Organization
 SELECT 
	  T.PDATE BILLDATE,
	  T.TRANSREF BILLNUMBER,
	  T.PERIOD   ,
	  P.PERIODDESC, 
	  T.ORDERNO  ,
	  T.CREDNO   , 
	  S.SUBNAME,
	  T.DESCRIPTION ,
	  T.DEBIT    ,
	  T.CREDIT   , 
	  T.TRANGRP  ,
	  T.CONTRACT ,
	  C.CONTRNAME,
	  T.ACTIVITY ,
	  A.ACTNAME,
	  T.TRANSID 
 INTO 
  #TEMP
 FROM 
  TRANSACTIONS  T 
  INNER JOIN PERIODMASTER P  ON T.PERIOD= P.PERIODID 
  INNER JOIN SUBCONTRACTORS S ON T.CREDNO = S.SUBNUMBER 
  INNER JOIN CONTRACTS C ON T.CONTRACT = C.CONTRNUMBER 
  INNER JOIN ACTIVITIES A ON T.Activity = A.ACTNUMBER 
 WHERE
  YEAR= @FINYEAR AND
  ORGID = @BORGID AND
  CREDNO = @CREDNO  AND
  LEDGERCODE = @SUBBIEADV
 ORDER BY
  TRANGRP, TRANSID 

 SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
 SELECT @FILENAME 
 SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP  ORDER BY PERIOD, TRANGRP, TRANSID  '
END

IF @ZONEID=0  AND @SUMMARY = 1
 -- Single Organization's all Subbies Summary  
 BEGIN
  SELECT 
   T.YEAR,
   T.ORGID,
   B.BORGNAME,
   T.CREDNO   , 
   S.SUBNAME,
   SUM( T.DEBIT - T.CREDIT ) OUTSTANDING    
  INTO 
    #TEMP1
 FROM 
  TRANSACTIONS  T 
  INNER JOIN PERIODMASTER P  ON T.PERIOD= P.PERIODID 
  INNER JOIN SUBCONTRACTORS S ON T.CREDNO = S.SUBNUMBER 
  INNER JOIN BORGS B ON T.ORGID=B.BORGID 
 WHERE
  YEAR= @FINYEAR AND
  ORGID = @BORGID AND
  LEDGERCODE = @SUBBIEADV
 GROUP BY
  T.YEAR, T.ORGID, B.BORGNAME, T.CREDNO , S.SUBNAME 
 ORDER BY
  T.CREDNO 

 DELETE FROM #TEMP1 WHERE OUTSTANDING = 0 

 SET @FILENAME = @FILENAME+'REGISTER'+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
 SELECT @FILENAME 
 SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP1 WHERE OUTSTANDING>0  ORDER BY ORGID, SUBNAME  '

 END    

IF @ZONEID=1  AND @SUMMARY = 1
 -- All Organization For All Subbie in Summary Only
 BEGIN
  SELECT 
   T.ORGID,
   B.BORGNAME,
   T.CREDNO   , 
   S.SUBNAME,
   SUM( T.DEBIT - T.CREDIT ) OUTSTANDING    
  INTO 
    #TEMP2
 FROM 
  TRANSACTIONS  T 
  INNER JOIN PERIODMASTER P  ON T.PERIOD= P.PERIODID 
  INNER JOIN SUBCONTRACTORS S ON T.CREDNO = S.SUBNUMBER 
  INNER JOIN BORGS B ON T.ORGID=B.BORGID 
 WHERE
  YEAR= @FINYEAR AND
  ORGID IN  ( SELECT BORGID FROM BORGS WHERE PARENTBORG = 5 ) AND
  LEDGERCODE = @SUBBIEADV
 GROUP BY
  T.ORGID, B.BORGNAME, T.CREDNO , S.SUBNAME 
 ORDER BY
  T.ORGID, T.CREDNO 
 
 DELETE FROM #TEMP2  WHERE OUTSTANDING = 0 
 SET @FILENAME = @FILENAME+'REGISTER'+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
 SELECT @FILENAME 
 SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP2  ORDER BY SUBNAME,BORGNAME   '
 END    

IF @ZONEID=1  AND @SUMMARY = 0  
 -- All Organization for a Single Subbie 
 BEGIN

 SELECT 
  T.PDATE BILLDATE,
  T.TRANSREF BILLNUMBER,
  T.PERIOD   ,
  P.PERIODDESC, 
  T.ORDERNO  ,
  T.CREDNO   , 
  S.SUBNAME,
  T.DESCRIPTION ,
  T.DEBIT    ,
  T.CREDIT   , 
  T.TRANGRP  ,
  T.CONTRACT ,
  C.CONTRNAME,
  T.ACTIVITY ,
  A.ACTNAME,
  T.TRANSID ,
  T.ORGID ,
  B.BORGNAME
 INTO 
  #TEMP3
 FROM 
  TRANSACTIONS  T 
  INNER JOIN PERIODMASTER P  ON T.PERIOD= P.PERIODID 
  INNER JOIN SUBCONTRACTORS S ON T.CREDNO = S.SUBNUMBER 
  INNER JOIN CONTRACTS C ON T.CONTRACT = C.CONTRNUMBER 
  INNER JOIN ACTIVITIES A ON T.Activity = A.ACTNUMBER 
  INNER JOIN BORGS B ON T.ORGID = B.BORGID 
 WHERE
  YEAR= @FINYEAR AND
  ORGID in (SELECT BORGID FROM #BORGS )  AND
  CREDNO = @CREDNO  AND
  LEDGERCODE = @SUBBIEADV
 ORDER BY
  TRANGRP, TRANSID 
 SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
 SELECT @FILENAME 
 SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP3  ORDER BY PERIOD,ORGID, TRANGRP, TRANSID  '
END



EXEC(@SQL)

RETURN @FILEID