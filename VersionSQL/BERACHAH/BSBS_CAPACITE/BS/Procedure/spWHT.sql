/****** Object:  Procedure [BS].[spWHT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BS].[spWHT](@FINYEAR INT,@STARTPERIOD INT,@ENDPERIOD INT,@ORGID INT,@ZONEID INT,@REPORTTYPE  INT) 
AS
    DECLARE @CREDITORCONTROL VARCHAR(10)
    SELECT  @CREDITORCONTROL = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
  
	DECLARE @SUBBIECONTROL VARCHAR(10)
	SELECT  @SUBBIECONTROL = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
	
	DECLARE @WHTCODEF VARCHAR(10)
	SELECT  @WHTCODEF = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors Withholding Tax'

	-- ReortType = 1  - Payable ONly
	-- ReportType = 2 - ALL transacitons 
	
	DECLARE @WHTPAYMENTBANKID VARCHAR(10)
	SET @WHTPAYMENTBANKID = '2557099'
              
    DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
	

	SET @FILENAME = 'BSBS_TEMP.DBO.WHT' 

 
    CREATE TABLE #BORGS(BORGID INT) 
    IF @ZONEID <> 0 
	 BEGIN
	    INSERT INTO #BORGS 
	    SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONEID 
		DELETE FROM #BORGS WHERE BORGID=2 
	 END
	ELSE
	    INSERT INTO #BORGS(BORGID) VALUES (@ORGID) 
	
	IF @ZONEID = 2
	   INSERT INTO #BORGS VALUES (2) 

	CREATE TABLE #TEMP0
	(
	 PERIOD INT,
	 TRANGRP INT,
	 TRANSID INT,
	 TRANSTYPE VARCHAR(3),
	 WHTID  VARCHAR(10),
	 WHTSECTION VARCHAR(25),
	 INVOICENUMBER VARCHAR(10),
	 VENDORCODE VARCHAR(15),
	 VENDORNAME VARCHAR(150),
	 PAN VARCHAR(15),
	 INVOICEAMOUNT DECIMAL(18,2),
	 TDSTAXRATE DECIMAL(18,2),
	 TDSDEBIT DECIMAL(18,2),
	 TDSCREDIT DECIMAL(18,2) ,
	 PAIDTODATE DECIMAL(18,2),
	 TRANSACTIONDATE DATETIME,
	 TAXNAME VARCHAR(50),
	 BORGID INT,
	 BORGNAME VARCHAR(150),
	 NARRATION VARCHAR(250),
	 ORDERNO   VARCHAR(50),
	 ORIGTRANSID INT ,
	 CURRENCY VARCHAR(10),
	 HOMECURRENCY MONEY
	)
    
	IF @REPORTTYPE = 1
       INSERT INTO #TEMP0 
	   SELECT PERIOD,TRANGRP,TRANSID,LEFT(TRANSTYPE,3),
	       WHTID,SPACE(25),TRANSREF,CREDNO,SPACE(150),
		   SPACE(15),0,0,DEBIT,CREDIT,PAIDTODATE,PDATE,
		   SPACE(50),ORGID,SPACE(50),DESCRIPTION ,ORDERNO ,ORIGTRANSID,CURRENCY,HomeCurrAmount  
	   FROM TRANSACTIONS 
	   WHERE ORGID IN (SELECT BORGID FROM #BORGS)  
	      AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD 
		  AND (CREDIT-DEBIT-PAIDTODATE)<>0
		  AND LEDGERCODE =  @WHTCODEF
		  AND YEAR = @FINYEAR 
		  AND PAIDFOR <> 1
	ELSE
	 BEGIN
	   INSERT INTO #TEMP0 
	   SELECT PERIOD,TRANGRP,TRANSID,LEFT(TRANSTYPE,3),
	       WHTID,SPACE(25),TRANSREF,CREDNO,SPACE(150),
		   SPACE(15),0,0,DEBIT,CREDIT,PAIDTODATE,PDATE,
		   SPACE(50),ORGID,SPACE(50),DESCRIPTION ,ORDERNO ,ORIGTRANSID,CURRENCY,HomeCurrAmount
	   FROM TRANSACTIONS 
	   WHERE ORGID IN (SELECT BORGID FROM #BORGS)  
	      AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD 
		  AND LEDGERCODE =  @WHTCODEF
		  AND TRANSTYPE<>'WHTP' 
		  AND YEAR = @FINYEAR 
       
	   INSERT INTO #TEMP0 
	   SELECT PERIOD,TRANGRP,TRANSID,LEFT(TRANSTYPE,3),
	       WHTID,SPACE(25),TRANSREF,CREDNO,SPACE(150),
		   SPACE(15),0,0,DEBIT,CREDIT,PAIDTODATE,PDATE,
		   SPACE(50),ORGID,SPACE(50),DESCRIPTION ,ORDERNO ,ORIGTRANSID,CURRENCY,HomeCurrAmount
	   FROM TRANSACTIONS 
	   WHERE ORGID IN (SELECT BORGID FROM #BORGS)  
	      AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD 
		  AND TRANSTYPE = 'WHTP'
		  AND LEDGERCODE =  @WHTCODEF
		   --AND DEBIT>0 
		  AND YEAR = @FINYEAR 
     END

    UPDATE #TEMP0 SET TDSDEBIT = HOMECURRENCY WHERE CURRENCY<>'INR'  AND TDSDEBIT>0 
	UPDATE #TEMP0 SET TDSCREDIT = HOMECURRENCY WHERE CURRENCY <> 'INR' AND TDSCREDIT>0 

    SELECT TRANGRP ,ISNULL(CREDNO,0) CREDNO INTO #VENDORS   FROM TRANSACTIONS
	WHERE  TRANGRP IN (SELECT TRANGRP FROM #TEMP0 WHERE TRANSTYPE IN ('CBC','CBD', 'JNL','WHTP' ) )  AND LEDGERCODE IN (@CREDITORCONTROL,@SUBBIECONTROL)

	UPDATE #TEMP0 SET VENDORCODE = V.CREDNO FROM #VENDORS V INNER JOIN #TEMP0 ON #TEMP0.TRANGRP = V.TRANGRP

    UPDATE #TEMP0 SET WHTSECTION = W.SECTION , TDSTAXRATE = W.RATE1 ,TAXNAME = W.DESCRIPTION    FROM TAXWHT W INNER JOIN #TEMP0 ON #TEMP0.WHTID = W.WHTID 
	UPDATE #TEMP0 SET VENDORNAME = LEFT(S.SUBNAME,250),PAN=S.PAN   FROM SUBCONTRACTORS S INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE  = S.SUBNUMBER WHERE #TEMP0.VENDORCODE<>''
	UPDATE #TEMP0 SET VENDORNAME = LEFT(C.CREDNAME,250),PAN=C.PAN  FROM CREDITORS C INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE = C.CREDNUMBER WHERE #TEMP0.VENDORCODE<>''
	UPDATE #TEMP0 SET VENDORNAME = LEFT(D.DEBTNAME,25),PAN=D.PAN   FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE = D.DEBTNUMBER WHERE #TEMP0.VENDORCODE <>'' 
	UPDATE #TEMP0 SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TEMP0 ON #TEMP0.BORGID = B.BORGID 
	UPDATE #TEMP0 SET PAN = C.PAN FROM CREDITORS C INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE = C.CredNumber 
	UPDATE #TEMP0 SET PAN = S.PAN FROM SUBCONTRACTORS  S INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE = S.SUBNUMBER 
	UPDATE #TEMP0 SET PAN = D.PAN FROM DEBTORS D INNER JOIN #TEMP0 ON #TEMP0.VENDORCODE = D.DEBTNUMBER 


    UPDATE #TEMP0 SET INVOICEAMOUNT = 0

    SELECT TRANGRP,ISNULL( ABS( SUM(CREDIT-DEBIT) ),0 )  INVOICEAMT ,CREDNO ,ORDERNO ,CURRENCY,SUM(HOMECURRAMOUNT) HOMECURRAMOUNT
	INTO #INVAMT
	FROM TRANSACTIONS 
	WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP0 WHERE TRANSTYPE IN ('SCP','CRI', 'SCI','CBC','CBD', 'PCP', 'PCR') ) 
	      AND LEDGERCODE IN ( @SUBBIECONTROL , @CREDITORCONTROL  )
		  AND SUBCONTRAN <> 'WithHolding Tax'
    GROUP BY TRANGRP ,CREDNO ,ORDERNO, CURRENCY
	
	UPDATE #INVAMT SET INVOICEAMT = HOMECURRAMOUNT WHERE CURRENCY <> 'INR'
	SELECT * FROM #INVAMT 
	UPDATE #TEMP0 SET INVOICEAMOUNT = I.INVOICEAMT FROM #INVAMT I  INNER JOIN #TEMP0 ON #TEMP0.TRANGRP = I.TRANGRP AND #TEMP0.VENDORCODE = I.CREDNO AND 
	#TEMP0.ORDERNO = I.ORDERNO 

	UPDATE #TEMP0 SET ORIGTRANSID = 0 WHERE ORIGTRANSID IS NULL

	

	
	UPDATE #TEMP0 SET INVOICEAMOUNT = 0 WHERE TRANSTYPE='JNL'
	UPDATE #TEMP0 SET INVOICEAMOUNT = 0 WHERE PERIOD = 0 
	UPDATE #TEMP0 SET INVOICEAMOUNT = 0 WHERE ORIGTRANSID <>0 

	ALTER TABLE #TEMP0 ADD STARTPERIOD VARCHAR(25)
	ALTER TABLE #TEMP0 ADD ENDPERIOD VARCHAR(25)
 
 
    UPDATE #TEMP0 SET STARTPERIOD = PS.DESCR FROM PERIODSETUP PS WHERE PS.PERIOD=@STARTPERIOD AND YEAR=@FINYEAR AND ORGID=@ORGID 
    UPDATE #TEMP0 SET ENDPERIOD = PS.DESCR FROM PERIODSETUP PS WHERE PS.PERIOD=@ENDPERIOD AND YEAR=@FINYEAR AND ORGID=@ORGID 

 

	ALTER TABLE #TEMP0 ADD REPORTYPE INT
	UPDATE #TEMP0 SET REPORTYPE = @REPORTTYPE

	ALTER TABLE #TEMP0 ADD MONTHNAMES VARCHAR(25)
	UPDATE #TEMP0 SET MONTHNAMES = PS.DESCR FROM PERIODSETUP PS INNER JOIN #TEMP0 ON #TEMP0.PERIOD = PS.PERIOD AND PS.ORGID= 2 

	DECLARE @Random INT;
	DECLARE @Upper INT;
	DECLARE @Lower INT
 
	SET @Lower = 1 ---- The lowest random number
	SET @Upper = 99999 ---- The highest random number
	SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

	SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
		+ (DATEPART(ss, GETDATE()) * 1000 )
		+ DATEPART(ms, GETDATE()) )*1000) + STR(@RANDOM) 

	SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(6),@FILEID)))

	SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0  ORDER BY PERIOD,WHTID,BORGID,TRANSACTIONDATE  '
   SELECT @FILENAME
   EXEC(@SQL)
   RETURN @FILEID
 