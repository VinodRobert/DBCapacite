/****** Object:  Procedure [BS].[spStockReportToSubbie]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spStockReportToSubbie]  ( @BORGID CHAR(3),                                   
															@STARTDATESTRING AS VARCHAR(15),
															@ENDDATESTRING AS VARCHAR(15) ) 														
															 
AS
BEGIN
 
 SET NOCOUNT ON
 DECLARE @STARTDATE     AS DATETIME
 DECLARE @ENDDATE       AS DATETIME
                           
 SELECT @STARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
 SELECT @ENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 
 


 SELECT  
       T.[TRANSTYPE] TRANSTYPE
      ,T.[STORE] STORE
      ,T.[STOCKNO] STOCKCODE
      ,T.[TRANSREF] REQREF
      ,T.[REQNO] SUBBIECODE
      ,T.[Quantity] QTY
      ,T.[ORGID] ORGID
      ,T.[PDATE] TRANSDATE 
	  ,T.TRANSID TRANSID
	  ,T.RATE 
	  ,I.STORENAME 
	  ,INV.STKUNIT 
	  ,INV.STKDESC 
	  ,S.SUBNAME 
  INTO #TEMP0 
  FROM [dbo].[TRANSACTIONS]  T
  INNER JOIN INVSTORES I ON I.STORECODE  = T.[STORE]
  INNER JOIN INVENTORY INV ON INV.STKCODE = T.STOCKNO AND INV.STKSTORE =  T.[STORE]
  INNER JOIN SUBCONTRACTORS S ON S.SUBNUMBER = T.REQNO
  WHERE T.[ORGID] = @BORGID AND 
        T.[PDATE] BETWEEN @STARTDATE AND @ENDDATE  AND
		T.TRANSTYPE IN ('SIC' ,'SSR' ) AND
		T.ALLOCATION='Contracts' 

  ALTER TABLE #TEMP0 ADD BORGNAME VARCHAR(100)
  ALTER TABLE #TEMP0 ADD STARTDATE DATETIME
  ALTER TABLE #TEMP0 ADD ENDDATE   DATETIME

  UPDATE #TEMP0 SET BORGNAME = (SELECT BORGNAME FROM BORGS WHERE BORGID=@BORGID) 
  UPDATE #TEMP0 SET STARTDATE = @STARTDATE
  UPDATE #TEMP0 SET ENDDATE = @ENDDATE 

  DECLARE @FILENAME VARCHAR(100)
  DECLARE @FILEID   VARCHAR(10)
  DECLARE @SQL      VARCHAR(250)
  SET @FILENAME = 'BSBS_TEMP.DBO.SUBBIETRANSFER'

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
  SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM  #TEMP0  ORDER BY SUBNAME  '
  EXEC(@SQL)

  SELECT @FILENAME 
  RETURN @FILEID
 
   
END