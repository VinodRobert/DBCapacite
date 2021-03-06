/****** Object:  Procedure [BS].[spStockReportInterCompanyTransfer]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spStockReportInterCompanyTransfer]  ( @BORGID CHAR(3),                                   
															@STARTDATESTRING AS VARCHAR(15),
															@ENDDATESTRING AS VARCHAR(15) ) 														
															 
AS
BEGIN
 
 SET NOCOUNT ON
 DECLARE @STARTDATE     AS DATETIME
 DECLARE @ENDDATE       AS DATETIME
 DECLARE @START         AS VARCHAR(10)
 DECLARE @END           AS VARCHAR(10)
 
 SELECT @START = CONTROLFROMGL FROM CONTROLCODES WHERE ControlName='STOCK' 
 SELECT @END=    CONTROLTOGL FROM CONTROLCODES WHERE ControlName = 'STOCK'                             
 SELECT @STARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
 SELECT @ENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 
 
 CREATE TABLE #TRANSFER 
  (
    FROMORG       VARCHAR(10),
	FROMSTORECODE VARCHAR(15),
	FROMSTORE     VARCHAR(150),
	TRANSDATE     DATETIME,
	STOCKCODE     VARCHAR(15),
	STOCKNAME     VARCHAR(250),
	ISSUEQTY      DECIMAL(18,4),
	RECEIPTQTY    DECIMAL(18,4),
	RATE          DECIMAL(18,2),
	UNIT          VARCHAR(15),
	VALUE         DECIMAL(18,2),
	TOORG         VARCHAR(10),
	TOSTORECODE   VARCHAR(15),
	TOSTORE       VARCHAR(150),
	TRANGRP       INT,
	TRANSID       INT
  )

  INSERT INTO #TRANSFER(FROMORG,FROMSTORECODE,TRANSDATE,STOCKCODE,ISSUEQTY,RECEIPTQTY,RATE,UNIT,VALUE,TRANGRP,TRANSID)     
  SELECT ORGID,STORE,PDATE,STOCKNO,QUANTITY,0,RATE,UNIT,CREDIT,TRANGRP,TRANSID 
  FROM TRANSACTIONS 
  WHERE ORGID=@BORGID  AND TRANSTYPE='XFR' AND QUANTITY<0 AND PDATE BETWEEN @STARTDATE AND @ENDDATE AND
  LEDGERCODE BETWEEN @START AND @END 
    
  INSERT INTO #TRANSFER(FROMORG,FROMSTORECODE,TRANSDATE,STOCKCODE,ISSUEQTY,RECEIPTQTY,RATE,UNIT,VALUE,TRANGRP,TRANSID)
  SELECT ORGID,STORE,PDATE,STOCKNO,0,QUANTITY,RATE,UNIT,DEBIT,TRANGRP,TRANSID  
  FROM TRANSACTIONS 
  WHERE ORGID=@BORGID  AND TRANSTYPE='XFR' AND QUANTITY>0 AND PDATE BETWEEN @STARTDATE AND @ENDDATE AND 
  LEDGERCODE BETWEEN @START AND @END 

  --SELECT ORGID,STORE,STOCKNO,TRANGRP,QUANTITY 
  --INTO #TRANSDUMP 
  --FROM TRANSACTIONS WHERE TRANSID IN (SELECT TRANSID FROM #TRANSFER) 

  UPDATE #TRANSFER 
  SET TOORG = ORGID ,
      TOSTORECODE = STORE 
  FROM  TRANSACTIONS
  INNER JOIN #TRANSFER ON #TRANSFER.TRANGRP = TRANSACTIONS.TRANGRP 
  WHERE #TRANSFER.STOCKCODE = TRANSACTIONS.STOCKNO AND
        ABS(#TRANSFER.ISSUEQTY) = ABS(TRANSACTIONS.QUANTITY)  AND 
		#TRANSFER.FROMSTORECODE<>TRANSACTIONS.STORE AND 
		#TRANSFER.ISSUEQTY < 0 
  
  UPDATE #TRANSFER 
  SET TOORG = ORGID ,
      TOSTORECODE = STORE 
  FROM TRANSACTIONS
  INNER JOIN #TRANSFER ON #TRANSFER.TRANGRP = TRANSACTIONS.TRANGRP 
  WHERE #TRANSFER.STOCKCODE = TRANSACTIONS.STOCKNO AND
        ABS(#TRANSFER.RECEIPTQTY) = ABS(TRANSACTIONS.QUANTITY)  AND 
		#TRANSFER.FROMSTORECODE<>TRANSACTIONS.STORE AND 
		#TRANSFER.RECEIPTQTY > 0 

  UPDATE #TRANSFER 
  SET FROMSTORE = I.STORENAME FROM INVSTORES I INNER JOIN #TRANSFER ON #TRANSFER.FROMSTORECODE = I.STORECODE
  
  UPDATE #TRANSFER 
  SET TOSTORE = I.STORENAME FROM INVSTORES I INNER JOIN #TRANSFER ON #TRANSFER.TOSTORECODE = I.STORECODE 

  UPDATE #TRANSFER 
  SET STOCKNAME = I.STKDESC  FROM INVENTORY I INNER JOIN #TRANSFER ON #TRANSFER.STOCKCODE = I.STKCODE AND #TRANSFER.FROMSTORECODE = I.STKSTORE 

  
  UPDATE #TRANSFER 
  SET STOCKNAME = I.STKDESC  FROM INVENTORY I INNER JOIN #TRANSFER ON #TRANSFER.STOCKCODE = I.STKCODE AND #TRANSFER.TOSTORECODE  = I.STKSTORE 

  DELETE FROM #TRANSFER WHERE FROMSTORECODE = 'VMAINSTORE' 
  DELETE FROM #TRANSFER WHERE TOSTORECODE = 'VMAINSTORE' 

  ALTER TABLE #TRANSFER ADD INDEXCODE INT

  UPDATE #TRANSFER SET INDEXCODE = 1 WHERE ISSUEQTY<>0
  UPDATE #TRANSFER SET INDEXCODE = 2 WHERE RECEIPTQTY<>0 

  ALTER TABLE #TRANSFER ADD BORGNAME VARCHAR(100)
  ALTER TABLE #TRANSFER ADD STARTDATE DATETIME
  ALTER TABLE #TRANSFER ADD ENDDATE   DATETIME

  UPDATE #TRANSFER SET BORGNAME = (SELECT BORGNAME FROM BORGS WHERE BORGID=@BORGID) 
  UPDATE #TRANSFER SET STARTDATE = @STARTDATE
  UPDATE #TRANSFER SET ENDDATE = @ENDDATE 

  DECLARE @FILENAME VARCHAR(100)
  DECLARE @FILEID   VARCHAR(10)
  DECLARE @SQL      VARCHAR(250)
  SET @FILENAME = 'BSBS_TEMP.DBO.STORETRANSFER'

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
  SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM  #TRANSFER  ORDER BY INDEXCODE  '
  EXEC(@SQL)

  SELECT @FILENAME 
  RETURN @FILEID
 
   
END