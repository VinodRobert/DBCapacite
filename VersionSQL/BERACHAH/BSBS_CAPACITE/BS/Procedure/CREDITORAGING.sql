/****** Object:  Procedure [BS].[CREDITORAGING]    Committed by VersionSQL https://www.versionsql.com ******/

 

CREATE PROCEDURE [BS].[CREDITORAGING](@YEAR INT,@ZONE INT)
AS
BEGIN
    UPDATE TRANSACTIONS SET RECEIVEDDATE = PDATE   WHERE YEAR=@YEAR AND TRANSTYPE='JNL' AND RECEIVEDDATE IS NULL 
    DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
	SET @FILENAME = 'BSBS_TEMP.DBO.CREDITORAGE'

	DECLARE @CREDITORS VARCHAR(10)
	SELECT @CREDITORS = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
	
	SELECT * INTO #TRANSDUMPS FROM TRANSACTIONS WHERE YEAR>=@YEAR  AND LEDGERCODE=@CREDITORS AND 
	ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONE ) 
	SELECT ORGID,CREDNO,SUM(DEBIT-CREDIT) LEDGERBALANCE INTO #LEDGERBALANCE FROM #TRANSDUMPS GROUP BY ORGID,CREDNO  



	DELETE FROM #TRANSDUMPS WHERE PAIDFOR=1

	DECLARE @LEDGERBALANCE DECIMAL(18,2) 

	SELECT 
		     T.YEAR,
			 T.PERIOD FINMONTH,
		     T.TRANGRP,
			 T.ORGID,
			 B.BORGNAME,
			 LEFT(BATCHREF,3)            TRANTYPE,
			 T.TRANSTYPE,
			 T.PDATE                     TRANSACTIONDATE,
			 RIGHT(T.TRANSREFEXT,16)     INVOCIENUMBER,
			 T.RECEIVEDDATE       INVOICEDATE,
			 (T.DEBIT-T.CREDIT)   INVOICEAMOUNT,
			 T.DEBIT              PAIDAMOUNT,
			 (T.CREDIT)           OUTSTANDINGAMOUNT,
			 0  AS PAID,
			 T.CREDNO           SUPPLIER,
			 C.CREDNAME         SUPPLIERNAME,
			 DATEDIFF(DAY,T.RECEIVEDDATE,GETDATE()) PERIOD,
			 0 AS               AGEBUCKET,
			 TRANSID 
     INTO #TEMP0 
	 FROM
			#TRANSDUMPS T 
			INNER JOIN BORGS B ON B.BORGID = T.ORGID 
			INNER JOIN CREDITORS C ON T.CREDNO = C.CREDNUMBER

    DELETE FROM #TEMP0 WHERE YEAR>@YEAR AND FINMONTH =0 
	UPDATE #TEMP0 SET PERIOD=0  WHERE PERIOD IS NULL


	
 


	UPDATE #TEMP0 SET AGEBUCKET = 0  WHERE PERIOD <= 30   
	UPDATE #TEMP0 SET AGEBUCKET = 30 WHERE PERIOD BETWEEN 31 AND 60  
	UPDATE #TEMP0 SET AGEBUCKET = 60 WHERE PERIOD BETWEEN 61 AND 90  
	UPDATE #TEMP0 SET AGEBUCKET = 90 WHERE PERIOD BETWEEN 91 AND 180  
	UPDATE #TEMP0 SET AGEBUCKET =180 WHERE PERIOD > 180 
	

 
	ALTER TABLE #TEMP0 ADD AGENAME VARCHAR(50)
	UPDATE #TEMP0 SET AGENAME='Current' WHERE AGEBUCKET =0
	UPDATE #TEMP0 SET AGENAME='31-60'   WHERE AGEBUCKET=30
	UPDATE #TEMP0 SET AGENAME='61-90'   WHERE AGEBUCKET=60
	UPDATE #TEMP0 SET AGENAME='91-180'  WHERE AGEBUCKET=90
	UPDATE #TEMP0 SET AGENAME='Above 180' WHERE AGEBUCKET=180
	 
	UPDATE #TEMP0 SET BORGNAME = B.BORGNAME FROM BORGS  B INNER JOIN #TEMP0 ON #TEMP0.ORGID=B.BORGID 
 
	 SELECT
         ORGID,
		 BORGNAME,
		 TRANSTYPE,
		 INVOCIENUMBER,
		 INVOICEDATE,
	     INVOICEAMOUNT,
		 PAIDAMOUNT,
		 OUTSTANDINGAMOUNT,
		 SUPPLIER,
		 SUPPLIERNAME,
		 PERIOD,
		 AGEBUCKET,
		 AGENAME
	  INTO #TEMP1
	  FROM #TEMP0 


	  SELECT ORGID, SUPPLIER,SUM(PAIDAMOUNT) TOTALPAID
	  INTO #TOTALPAID
	  FROM #TEMP0
	  WHERE PAIDAMOUNT>0
	  GROUP BY ORGID,SUPPLIER



	 ALTER TABLE #TEMP1 ADD TOTALPAID DECIMAL(18,2)  
	 UPDATE #TEMP1 SET TOTALPAID=0

	 DECLARE @PSUPPLIER VARCHAR(10)
	 DECLARE @PPAID MONEY
	 DECLARE @PORGID INT 
	 DECLARE @CNTS INT 

	 DECLARE PAYMENTS CURSOR FOR SELECT ORGID,SUPPLIER,TOTALPAID FROM #TOTALPAID
	 OPEN PAYMENTS
	 FETCH NEXT FROM PAYMENTS INTO @PORGID,@PSUPPLIER,@PPAID 
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
	    SELECT @CNTS = COUNT(*) FROM #TEMP1 WHERE SUPPLIER = @PSUPPLIER AND ORGID=@PORGID 
		IF @CNTS >0 
		 BEGIN
		    UPDATE #TEMP1 SET TOTALPAID = @PPAID WHERE SUPPLIER = @PSUPPLIER AND ORGID =@PORGID 
		 END
		ELSE
		 BEGIN
		     ----SELECT @PORGID,@PSUPPLIER,@PPAID 
		     INSERT INTO #TEMP1(ORGID,SUPPLIER,TOTALPAID,TRANSTYPE,INVOCIENUMBER,INVOICEDATE,INVOICEAMOUNT,PAIDAMOUNT,AGEBUCKET )
			 VALUES (@PORGID,@PSUPPLIER,@PPAID,'CBC' ,0,NULL,0,0,0)
		 END
	    FETCH NEXT FROM PAYMENTS INTO @PORGID,@PSUPPLIER,@PPAID
	 END
	 CLOSE PAYMENTS
	 DEALLOCATE PAYMENTS

	

	 UPDATE #TEMP1 SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TEMP1 ON #TEMP1.ORGID=B.BORGID 
	 UPDATE #TEMP1 SET SUPPLIERNAME = C.CREDNAME   FROM CREDITORS C INNER JOIN #TEMP1 ON #TEMP1.SUPPLIER = C.CredNumber  
	 ALTER TABLE #TEMP1 ADD LEDGERBALANCE DECIMAL(18,2) 
	 UPDATE #TEMP1 SET LEDGERBALANCE = 0 
	


     --SELECT ORGID,SUM(OUTSTANDINGAMOUNT-PAID) NETPAYABLE FROM #TEMP0 GROUP BY ORGID ORDER BY ORGID
	 SELECT SUPPLIER,SUM(OUTSTANDINGAMOUNT-PAID) NETPAYABLE FROM #TEMP0 WHERE ORGID=121 GROUP BY SUPPLIER ORDER BY SUPPLIER 
     UPDATE #TEMP1 SET LEDGERBALANCE = L.LEDGERBALANCE FROM #LEDGERBALANCE L INNER JOIN #TEMP1 ON #TEMP1.ORGID=L.ORGID AND #TEMP1.SUPPLIER=L.Credno


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
     SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP1  ORDER BY SUPPLIERNAME,ORGID  '
	 EXEC(@SQL)
	 SELECT @FILENAME 
     RETURN @FILEID
 
  
 END
 