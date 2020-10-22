/****** Object:  Procedure [BS].[LEDGERTRANSACTIONLISTING]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BS].[LEDGERTRANSACTIONLISTING](@BORGID INT,@ZONEID INT, @FINYEAR INT,@LEDGERCODE VARCHAR(10),@STARTDATESTRING VARCHAR(15),@ENDDATESTRING VARCHAR(15) )
AS
BEGIN
	DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
	SET @FILENAME = 'BSBS_TEMP.DBO.LEDGERTRANSSTATEMENT'
	DECLARE @ORGID INT 

	DECLARE @LEDGERALLOC VARCHAR(10)
	SELECT @LEDGERALLOC  = LEDGERALLOC FROM LEDGERCODES WHERE LEDGERCODE= @LEDGERCODE 

	CREATE TABLE #TRANSLIST 
	(
	 ID INT PRIMARY KEY IDENTITY ,
	 INDEXCODE INT,
	 ORGID INT,
	 PDATE DATETIME,
	 TRANSTYPE VARCHAR(10),
	 DESCRIPTION VARCHAR(255),
	 DEBIT MONEY,
	 CREDIT MONEY,
	 PERIOD INT,
	 TRANGRP INT
	)
	
	CREATE TABLE  #BORGS(BORGID INT)

	DECLARE @OPENINGBALANCE DECIMAL(18,2)
	DECLARE @OPBAL_BILL DECIMAL(18,2)
	DECLARE @OPBAL_PAY  DECIMAL(18,2)
	DECLARE @BROUGHTFORWARD INT
	DECLARE @LEDGERNAME  VARCHAR(100)
	DECLARE @STARTDATE     DATETIME
	DECLARE @ENDDATE       DATETIME
	SELECT  @STARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
	SELECT  @ENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 

	DECLARE @SEALINGDATE DATETIME
	SELECT @SEALINGDATE = PEDATE FROM PERIODSETUP WHERE YEAR=@FINYEAR  AND PERIOD=0 AND ORGID=2
	IF @STARTDATE = @SEALINGDATE 
	   SET @BROUGHTFORWARD = 1
	ELSE
	   SET @BROUGHTFORWARD = 0

    
	IF @ZONEID <> 0 
	    INSERT INTO #BORGS 
	    SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONEID 
	ELSE
	    INSERT INTO #BORGS(BORGID) VALUES (@BORGID) 
		
	DECLARE BORGS CURSOR    FOR SELECT BORGID FROM #BORGS ORDER BY BORGID 
	OPEN BORGS
	FETCH NEXT FROM BORGS INTO @ORGID 
	WHILE @@FETCH_STATUS  = 0
	BEGIN

		SET @OPENINGBALANCE = 0 

		IF @BROUGHTFORWARD = 1
		   SELECT @OPENINGBALANCE  = SUM(DEBIT-CREDIT) 
		   FROM TRANSACTIONS
		   WHERE ORGID = @ORGID AND
				 YEAR = @FINYEAR AND
				 PERIOD = 0 AND
				 LEDGERCODE = @LEDGERCODE 
		ELSE
		   SELECT @OPENINGBALANCE = SUM(DEBIT-CREDIT) 
		   FROM  TRANSACTIONS 
		   WHERE ORGID = @ORGID AND
		   YEAR = @FINYEAR AND
		   PDATE < @STARTDATE AND
		   LEDGERCODE = @LEDGERCODE 

        INSERT INTO #TRANSLIST
		SELECT 
			   2 AS INDEXCODE ,
			   ORGID,
			   PDATE,
			   LEFT(TRANSTYPE,3) TRANSTYPE,
			   UPPER(DESCRIPTION) DESCRIPTION,
			   DEBIT,
			   CREDIT,
			   PERIOD,
			   TRANGRP  
			FROM 
			   TRANSACTIONS 
			WHERE
			   ORGID = @ORGID AND
			   YEAR = @FINYEAR AND
			   PDATE BETWEEN @STARTDATE AND @ENDDATE AND
			   LEDGERCODE = @LEDGERCODE  
	
		IF @BROUGHTFORWARD = 1
		   DELETE FROM #TRANSLIST WHERE PERIOD=0  AND ORGID =@ORGID 
        
	

		IF @BROUGHTFORWARD = 1
		   IF @OPENINGBALANCE > 0
			  INSERT INTO #TRANSLIST(INDEXCODE,ORGID,PDATE,TRANSTYPE,DESCRIPTION,DEBIT,CREDIT,PERIOD,TRANGRP) 
			  VALUES (1,@ORGID,NULL,'OB','Opening Balance ',@OPENINGBALANCE,0,0,0)
		   ELSE
			  INSERT INTO #TRANSLIST(INDEXCODE,ORGID,PDATE,TRANSTYPE,DESCRIPTION,DEBIT,CREDIT,PERIOD,TRANGRP) 
			  VALUES (1,@ORGID,NULL,'B/F','Opening Balance ',0,ABS(@OPENINGBALANCE),0,0)
		ELSE
		   IF @OPENINGBALANCE > 0
			  INSERT INTO #TRANSLIST(INDEXCODE,ORGID,PDATE,TRANSTYPE,DESCRIPTION,DEBIT,CREDIT,PERIOD,TRANGRP) 
			  VALUES (1,@ORGID,NULL,'B/F','Brought Forward  ',@OPENINGBALANCE,0,0,0 )
		   ELSE
			  INSERT INTO #TRANSLIST(INDEXCODE,ORGID,PDATE,TRANSTYPE,DESCRIPTION,DEBIT,CREDIT,PERIOD,TRANGRP) 
			  VALUES (1,@ORGID,NULL,'B/F','Brought Forward ',0,ABS(@OPENINGBALANCE),0,0)
    
	
	FETCH NEXT FROM BORGS INTO @ORGID 

    END
	CLOSE BORGS
	DEALLOCATE BORGS

	ALTER TABLE #TRANSLIST ADD  MOREINFO VARCHAR(255)
	ALTER TABLE #TRANSLIST ADD  FROMDATE DATETIME
	ALTER TABLE #TRANSLIST ADD  POSTDATE DATETIME

	UPDATE #TRANSLIST 
	  SET MOREINFO =ISNULL(A.REMARK,SPACE(1)),
	      FROMDATE = A.FROMDATE,
		  POSTDATE = A.POSTDATE 
	  FROM SUBCRECONS_ARCHIEVE A 
	  INNER JOIN #TRANSLIST ON #TRANSLIST.TRANGRP = A.TRANGRP 

    SELECT ID,
	 ISNULL( LEN(LTRIM(RTRIM(DESCRIPTION))),0) LEN1,
	 DESCRIPTION,
	 ISNULL(LEN(LTRIM(RTRIM(MOREINFO))),0) LEN2,
	 MOREINFO,
	 SPACE(255) FINALMEMO
	INTO #TEMPDESC 
	FROM #TRANSLIST
	ALTER TABLE #TEMPDESC ADD LEN3 INT
	UPDATE #TEMPDESC SET LEN3= LEN1+LEN2 

	SELECT * FROM #TEMPDESC 

	UPDATE #TEMPDESC 
	 SET FINALMEMO = LTRIM(RTRIM(DESCRIPTION)) WHERE LEN2= 0
	UPDATE #TEMPDESC 
	 SET FINALMEMO  = LTRIM(RTRIM(DESCRIPTION)) + ' '+LOWER(LTRIM(RTRIM(MOREINFO))) WHERE LEN3 < 254 AND LEN2>0 
	UPDATE #TEMPDESC 
	 SET FINALMEMO = LTRIM(RTRIM(DESCRIPTION)) + ' '+ LOWER(   SUBSTRING(   LTRIM(RTRIM(MOREINFO)) ,1 ,(254-LEN1) ) )
	 WHERE LEN1+LEN2 > 255 AND LEN2 > 0

	UPDATE #TRANSLIST
	SET DESCRIPTION = T.FINALMEMO FROM #TEMPDESC T 
	INNER JOIN #TRANSLIST ON #TRANSLIST.ID = T.ID 

	IF @LEDGERALLOC <> 'Balance Sheet' 
		   DELETE FROM #TRANSLIST WHERE INDEXCODE = 1

	UPDATE #TRANSLIST SET DEBIT=0 WHERE DEBIT IS NULL
	UPDATE #TRANSLIST SET CREDIT=0 WHERE CREDIT IS NULL
	DELETE FROM #TRANSLIST WHERE DEBIT=0 AND CREDIT=0 

	ALTER TABLE #TRANSLIST ADD BORGNAME VARCHAR(100)
	ALTER TABLE #TRANSLIST ADD STARTDATE DATETIME
	ALTER TABLE #TRANSLIST ADD ENDDATE  DATETIME 
	ALTER TABLE #TRANSLIST ADD LEDGERCODE VARCHAR(10)
	ALTER TABLE #TRANSLIST ADD LEDGERNAME VARCHAR(100)

	SELECT @LEDGERNAME = LEDGERNAME FROM LEDGERCODES WHERE LEDGERCODE=@LEDGERCODE 
	UPDATE #TRANSLIST SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TRANSLIST ON #TRANSLIST.OrgID  = B.BORGID
	UPDATE #TRANSLIST SET LEDGERCODE = @LEDGERCODE
	UPDATE #TRANSLIST SET LEDGERNAME = @LEDGERNAME 
	UPDATE #TRANSLIST SET STARTDATE = @STARTDATE
	UPDATE #TRANSLIST SET ENDDATE = @ENDDATE 


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
    SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TRANSLIST   ORDER BY ORGID,INDEXCODE,PDATE   '
	EXEC(@SQL)
	SELECT @LEDGERCODE 
	SELECT * FROM #TRANSLIST ORDER BY ORGID,INDEXCODE,PDATE 
	SELECT @FILENAME 
    RETURN @FILEID
END