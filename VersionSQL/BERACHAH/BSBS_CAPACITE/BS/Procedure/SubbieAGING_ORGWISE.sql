/****** Object:  Procedure [BS].[SubbieAGING_ORGWISE]    Committed by VersionSQL https://www.versionsql.com ******/

 

CREATE PROCEDURE [BS].[SubbieAGING_ORGWISE](@YEAR INT,@ORGID INT)
AS
BEGIN
    UPDATE TRANSACTIONS SET RECEIVEDDATE = PDATE   WHERE YEAR=@YEAR AND TRANSTYPE='JNL' AND RECEIVEDDATE IS NULL 
    DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
	SET @FILENAME = 'BSBS_TEMP.DBO.CREDITORAGEORG'

	DECLARE @CREDITORS VARCHAR(10)
	SELECT @CREDITORS = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
	 
  
	SELECT * INTO #TEMP0 FROM
	(
		SELECT 
		     T.TRANGRP,
			 T.ORGID,
			 B.BORGNAME,
			 LEFT(BATCHREF,3) TRANTYPE,
			 T.TRANSTYPE,
			 T.PDATE        TRANSACTIONDATE,
			 RIGHT(T.TRANSREFEXT,16)     INVOCIENUMBER,
			 T.RECEIVEDDATE INVOICEDATE,
			 T.CREDIT       INVOICEAMOUNT,
			 T.PAIDTODATE   PAIDAMOUNT,
			 (T.CREDIT-T.PAIDTODATE) OUTSTANDINGAMOUNT,
			 0  AS PAID,
			 T.CREDNO       SUPPLIER,
			 C.CREDNAME     SUPPLIERNAME,
			 DATEDIFF(DAY,T.RECEIVEDDATE,GETDATE()) PERIOD,
			 0 AS           AGEBUCKET,
			 TRANSID 
		FROM
			TRANSACTIONS T 
			INNER JOIN BORGS B ON B.BORGID = T.ORGID 
			INNER JOIN CREDITORS C ON T.CREDNO = C.CREDNUMBER
		WHERE 
			LEDGERCODE=@CREDITORS AND
			(T.CREDIT-T.PAIDTODATE) <> 0 AND 
			YEAR >= @YEAR AND
			ORGID=@ORGID AND
			PAIDFOR <> 1 AND
			TRANSTYPE<>'CRA'
      UNION
		SELECT 
		     T.TRANGRP,
			 T.ORGID,
			 B.BORGNAME,
			 LEFT(BATCHREF,3) TRANTYPE,
			 T.TRANSTYPE,
			 T.PDATE        TRANSACTIONDATE,
			 RIGHT(T.TRANSREFEXT,16)     INVOCIENUMBER,
			 T.RECEIVEDDATE INVOICEDATE,
			 T.CREDIT       INVOICEAMOUNT,
			 T.PAIDTODATE   PAIDAMOUNT,
			 0              OUTSTANDINGAMOUNT,
			 T.DEBIT        PAID,
			 T.CREDNO       SUPPLIER,
			 C.CREDNAME     SUPPLIERNAME,
			 DATEDIFF(DAY,T.PDATE,GETDATE()) PERIOD,
			 0 AS           AGEBUCKET,
			 TRANSID 
	    FROM
			TRANSACTIONS T 
			INNER JOIN BORGS B ON B.BORGID = T.ORGID 
			INNER JOIN CREDITORS C ON T.CREDNO = C.CREDNUMBER
		WHERE 
			LEDGERCODE=@CREDITORS AND
			(T.DEBIT) > 0 AND 
			YEAR >= @YEAR AND
			ORGID=@ORGID  AND
			PAIDFOR <> 1 AND
			TRANSTYPE <> 'CRA'
      ) T

	SELECT * FROM #TEMP0 ORDER BY SUPPLIERNAME

	UPDATE #TEMP0 SET PERIOD=0  WHERE PERIOD IS NULL
	--UPDATE #TEMP0 SET PERIOD = DATEDIFF(DAY,TRANSACTIONDATE,GETDATE())  WHERE OUTSTANDINGAMOUNT >0 AND PERIOD=0 
	--UPDATE #TEMP0 SET INVOICEDATE=RECEIVEDDATE  WHERE OUTSTANDINGAMOUNT >0
 


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
	  WHERE OUTSTANDINGAMOUNT<>0

	  SELECT ORGID, SUPPLIER,SUM(PAID) TOTALPAID
	  INTO #TOTALPAID
	  FROM #TEMP0
	  WHERE PAID>0
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
		     SELECT @PORGID,@PSUPPLIER,@PPAID 
		     INSERT INTO #TEMP1(ORGID,SUPPLIER,TOTALPAID,TRANSTYPE,INVOCIENUMBER,INVOICEDATE,INVOICEAMOUNT,PAIDAMOUNT,AGEBUCKET )
			 VALUES (@PORGID,@PSUPPLIER,@PPAID,'CBC' ,0,NULL,0,0,0)
		 END
	    FETCH NEXT FROM PAYMENTS INTO @PORGID,@PSUPPLIER,@PPAID
	 END
	 CLOSE PAYMENTS
	 DEALLOCATE PAYMENTS

     --DELETE FROM #TEMP1 WHERE OUTSTANDINGAMOUNT = TOTALPAID 
	 --Deleted on 03 Sept 2015 - JSW Steel 

	 UPDATE #TEMP1 SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TEMP1 ON #TEMP1.ORGID=B.BORGID 
	 UPDATE #TEMP1 SET SUPPLIERNAME = C.SUBNAME    FROM SUBCONTRACTORS C INNER JOIN #TEMP1 ON #TEMP1.SUPPLIER = C.SUbNumber
		 


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
 