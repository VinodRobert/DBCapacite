/****** Object:  Procedure [BS].[DEBTOREGISTER]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[DEBTOREGISTER]( @FINYEAR INT,@STARTDATESTRING VARCHAR(15),@ENDDATESTRING VARCHAR(15),@ORGID INT,@ZONEID INT ) 
AS
    DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
	DECLARE @WIP      VARCHAR(10)

	SELECT @WIP = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Work In Progress'



	DECLARE @UNCERTIFIEDSTART VARCHAR(10)
	DECLARE @UNCERTIFIEDEND   VARCHAR(10)
	SET @UNCERTIFIEDSTART = '4010001'
	SET @UNCERTIFIEDEND = '4010003'



	DECLARE @CERTIFIEDSTART VARCHAR(10)
	DECLARE @CERTIFIEDEND   VARCHAR(10)
	SET @CERTIFIEDSTART = '4010000'
	SET @CERTIFIEDEND   = '4010000'

	DECLARE @OTHERREVENUESTART VARCHAR(10)
	DECLARE @OTHERREVENUEEND   VARCHAR(10)
	SET @OTHERREVENUESTART = '4510000'
	SET @OTHERREVENUEEND = '4519999'

	DECLARE @FIM VARCHAR(10)
	SET @FIM='4010006'

	DECLARE @VAT VARCHAR(10)
	SET @VAT = '4010004'

	DECLARE @ST VARCHAR(10)
	SET @ST = '4010005'


	DECLARE @MOBADV VARCHAR(10)
	SET @MOBADV = '2541000'

	DECLARE @SECUREDADV VARCHAR(10)
	SET @SECUREDADV = '2541001'


	DECLARE @OTHERCHARGESSTART VARCHAR(10)
	DECLARE @OTHERCHARGESEND   VARCHAR(10)
	SET @OTHERCHARGESSTART = '5000000'
	SET @OTHERCHARGESEND   = '5999999'

	DECLARE @VATPAYABLE VARCHAR(10)
	SET @VATPAYABLE = '1310000'

	DECLARE @STPAYABLE VARCHAR(10)
	SET @STPAYABLE = '1310002'

	DECLARE @TDSIT VARCHAR(10)
	SET @TDSIT = '2570004'

	DECLARE @VATTDS VARCHAR(10)
	SET @VATTDS = '2570003'

	DECLARE @RETENTION VARCHAR(10)
	SET @RETENTION  = '2540004'

	DECLARE @CLIENTWITHHELDONE VARCHAR(10)
	DECLARE @CLIENTWITHHELDTWO  VARCHAR(10)
	SET @CLIENTWITHHELDONE = '2540003'
	SET @CLIENTWITHHELDTWO = '2540005'

    CREATE TABLE #TEMP0 
	(
	 TRANGRP INT,
	 CREDNO  VARCHAR(10),
	 PERIOD INT,
	 BILLNUMBER VARCHAR(10),
	 BILLDATE VARCHAR(10),
	 UNCERTIFIED MONEY,
	 CERTIFIED MONEY,
	 OTHERREVENUE MONEY,
	 VAT MONEY,
	 ST MONEY,
	 TOTALREVENUE MONEY,
	 MOBADV MONEY,
	 SECUREDADVDEBIT MONEY,
	 SECUREDADVCREDIT MONEY,
	 OTHERCHARGES MONEY,
	 VATPAYABLE MONEY,
	 STPAYABLE MONEY,
	 TDSID MONEY,
	 VATTDS MONEY,
	 RETENTIONS MONEY,
	 WITHHELD MONEY,
	 CREDIT MONEY,
	 DEBIT MONEY
	)








 
	DECLARE @STARTDATE     DATETIME
	DECLARE @ENDDATE       DATETIME
	SELECT @STARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
	SELECT @ENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 
	SET @FILENAME = 'BSBS_TEMP.DBO.SALE' 

 
    CREATE TABLE #BORGS(BORGID INT) 
    IF @ZONEID <> 0 
	    INSERT INTO #BORGS 
	    SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONEID 
	ELSE
	    INSERT INTO #BORGS(BORGID) VALUES (@ORGID) 

	SELECT T.ORGID,T.YEAR,T.PERIOD,T.BATCHREF,T.TRANGRP,T.PDATE,T.TRANSID,
	       T.TRANSREF,T.LEDGERCODE,T.ACTIVITY,T.DESCRIPTION,T.DEBIT,
		   T.CREDIT,T.CREDNO,UPPER(D.DEBTNAME) DEBTNAME,B.BORGNAME,UPPER(L.LEDGERNAME) LEDGERNAME ,
		   T.ALLOCATION,A.ACTNAME,@STARTDATE STARTDATE,@ENDDATE ENDDATE 
	INTO #TEMP1
    FROM TRANSACTIONS T INNER JOIN BORGS B ON T.ORGID = B.BORGID 
    INNER JOIN LEDGERCODES L ON L.LEDGERCODE=T.LEDGERCODE  
    INNER JOIN DEBTORS D ON D.DEBTNUMBER = T.CREDNO 
	INNER JOIN ACTIVITIES A ON T.Activity = A.ActNumber
	WHERE LEFT(BATCHREF,3)='DTI'  AND T.LEDGERCODE<>@WIP AND
	T.ORGID IN (SELECT BORGID FROM #BORGS) AND
	T.YEAR = @FINYEAR AND
	T.PDATE BETWEEN @STARTDATE AND @ENDDATE 
	ORDER BY ORGID,TRANGRP,TRANSID 

	ALTER TABLE #TEMP1 ADD REMARK VARCHAR(250)
	ALTER TABLE #TEMP1 ADD FROMDATE DATETIME 

	SELECT  TRANGRP, REMARK,FROMDATE
	INTO #TEMP2 
    FROM DEBTRECONS_ARCHIEVE 
	WHERE TRANGRP IN (SELECT DISTINCT TRANGRP FROM #TEMP1) 
	SELECT * FROM #TEMP2 

	UPDATE #TEMP1 SET REMARK = T.REMARK, FROMDATE = T.FROMDATE FROM 
	#TEMP2 T INNER JOIN #TEMP1 ON #TEMP1.TRANGRP = T.TRANGRP 

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
    SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP1  ORDER BY ORGID,DEBTNAME,TRANGRP,ALLOCATION,LEDGERCODE DESC   '
	EXEC(@SQL)
	SELECT @FILENAME 
    RETURN @FILEID