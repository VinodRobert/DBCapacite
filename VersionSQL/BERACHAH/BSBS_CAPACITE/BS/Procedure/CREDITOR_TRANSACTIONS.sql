/****** Object:  Procedure [BS].[CREDITOR_TRANSACTIONS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[CREDITOR_TRANSACTIONS](@BORGID INT,@ZONE INT, @FROMPERIOD INT, @TOPERIOD INT,@FINYEAR INT , @CREDNO VARCHAR(10))
AS
    DECLARE @CHECKJVCOMPANY INT
	SELECT @CHECKJVCOMPANY = PARENTBORG FROM BORGS WHERE BORGID=@BORGID 
	IF @CHECKJVCOMPANY = 27
	   -- JV COMPNAY
	   SET @ZONE=0
	
	DECLARE @CREDITORCONTROL VARCHAR(10)
    SELECT @CREDITORCONTROL = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
   
    DECLARE @FILENAME VARCHAR(100)
	DECLARE @FILEID   VARCHAR(10)
	DECLARE @SQL      VARCHAR(250)
    DECLARE @ORGID INT

	SET @FILENAME = 'BSBS_TEMP.DBO.CREDITOR_MOVEMENT'
    
	DECLARE @BROUGHTFORWARD INT
 


 
	--SELECT @STARTDATESTRING
 --   SELECT @ENDDATESTRING
	--SELECT @TRANSSTARTDATE
	--SELECT @TRANSENDDATE
	--SELECT @FINYEAR 

    DECLARE @SEALINGDATE DATETIME
	SELECT @SEALINGDATE = PEDATE FROM PERIODSETUP WHERE YEAR=@FINYEAR  AND PERIOD=0 AND ORGID=2

	IF @FROMPERIOD  = 0 
	   SET @BROUGHTFORWARD = 1
	ELSE
	   SET @BROUGHTFORWARD = 0
  	 
   --SELECT @BROUGHTFORWARD

   CREATE TABLE #BORGS(BORGID INT)
   IF @ZONE <> 0 
        INSERT INTO #BORGS 
	    SELECT BORGID   FROM BORGS WHERE PARENTBORG = @ZONE
	ELSE
	    INSERT INTO #BORGS VALUES (  @BORGID )

   --SELECT * FROM #BORGS 

   DECLARE @KEYS INT
   DECLARE @ORDERNUMBER VARCHAR(25)
   DECLARE @ORDID INT
   DECLARE @ALLOCATION VARCHAR(20) 
   DECLARE @FIRSTSTOCKID INT
   DECLARE @STORENAME   VARCHAR(15) 
   DECLARE @CONTRACTNO  VARCHAR(10)
   DECLARE @CONTRACT    VARCHAR(125)
   SELECT @CREDNO 

   CREATE TABLE #TEMP0
   (
   KEYS  INT IDENTITY(1,1),
   INDEXCODE    INT,
   PERIOD		INT,
   BATCHREF		VARCHAR(10),
   TRANSREF		VARCHAR(10),
   TRANSTYPE	VARCHAR(30),
   PDATE		DATETIME,
   DESCRIPTION	VARCHAR(255),
   DEBIT		DECIMAL(18,2),
   CREDIT		DECIMAL(18,2),
   CREDNO		VARCHAR(40),
   CREDITORNAME VARCHAR(250),
   DOCUNUMBER	VARCHAR(255),
   USERID		VARCHAR(250),
   ORDERNUMBER  VARCHAR(200),
   TRANGRP      INT,
   ORGID        INT
   )


   DELETE FROM #TEMP0

   DECLARE BORGS CURSOR FOR SELECT BORGID FROM #BORGS 
   OPEN BORGS
   FETCH NEXT FROM BORGS INTO @ORGID 
   WHILE @@FETCH_STATUS = 0 
   BEGIN
	   INSERT INTO #TEMP0
	   SELECT 
		2,
		T.PERIOD,
		T.BATCHREF,
		T.TRANSREF,
		T.TRANSTYPE,
		T.PDATE,
		T.DESCRIPTION,
		T.DEBIT,
		T.CREDIT,
		T.CREDNO,
		SPACE(100),
		T.DOCNUMBER,
		T.USERID,
		T.ORDERNO ,
		T.TRANGRP ,
		@ORGID 
	  FROM
		TRANSACTIONS T
	  WHERE
		LEDGERCODE = @CREDITORCONTROL AND 
		ORGID = @ORGID  AND 
		T.PERIOD >=@FROMPERIOD AND T.PERIOD<=@TOPERIOD  AND 
		YEAR=@FINYEAR AND 
		T.CREDNO =@CREDNO
  
	   IF @BROUGHTFORWARD = 1 
		 DELETE FROM #TEMP0 WHERE PERIOD=0 AND ORGID = @ORGID 
       
	  

	   IF @BROUGHTFORWARD = 1
	    INSERT INTO #TEMP0 (INDEXCODE,DESCRIPTION,DEBIT,CREDIT,CREDNO,ORGID ) 
	    SELECT 
		 1,
		 'Opening Balance',
		 SUM(DEBIT) ,
		 SUM(CREDIT) ,
		 @CREDNO ,
		 @ORGID 
	    FROM 
		 TRANSACTIONS 
	    WHERE  
		 LEDGERCODE = @CREDITORCONTROL 
		 AND ORGID = @ORGID  AND 
		 PERIOD=0  AND 
		 YEAR= @FINYEAR AND 
		 CREDNO = @CREDNO
       ELSE
         INSERT INTO #TEMP0 (INDEXCODE,DESCRIPTION,DEBIT,CREDIT,CREDNO,ORGID ) 
	      SELECT 
		   1,
		  'Brought Forward',
		  SUM(DEBIT) ,
		  SUM(CREDIT) ,
		  @CREDNO ,
		  @ORGID 
	     FROM 
		  TRANSACTIONS 
	     WHERE  
		   LEDGERCODE = @CREDITORCONTROL AND 
		   ORGID = @ORGID  AND 
		   PERIOD <@FROMPERIOD   AND 
		   YEAR= @FINYEAR AND 
		   CREDNO = @CREDNO
  
         UPDATE #TEMP0 SET CREDIT=(CREDIT-DEBIT),DEBIT=0 FROM #TEMP0 WHERE ( DESCRIPTION LIKE 'Opening Balance%' OR DESCRIPTION LIKE 'Brought Forward%' ) AND CREDIT>DEBIT 
         UPDATE #TEMP0 SET DEBIT=(DEBIT-CREDIT),CREDIT=0  FROM #TEMP0 WHERE ( DESCRIPTION LIKE 'Opening Balance%' OR DESCRIPTION LIKE 'Brought Forward%' ) AND DEBIT> CREDIT
     FETCH NEXT FROM BORGS INTO @ORGID 
  END

  UPDATE #TEMP0 SET DEBIT=0 WHERE DEBIT IS NULL
  UPDATE #TEMP0 SET CREDIT=0 WHERE CREDIT IS NULL
  DELETE FROM #TEMP0 WHERE DEBIT=0 AND CREDIT=0 

  ALTER TABLE #TEMP0 ADD  PROJECT VARCHAR(150)
  ALTER TABLE #TEMP0 ADD  SHORTDESCRIPTION VARCHAR(150) 
  ALTER TABLE #TEMP0 ADD  BANKNAME VARCHAR(50)
  
  DECLARE STORES CURSOR FOR
  SELECT KEYS, ORDERNUMBER FROM #TEMP0 
  OPEN STORES
  FETCH NEXT FROM STORES INTO @KEYS, @ORDERNUMBER 
  WHILE @@FETCH_STATUS = 0
  BEGIN
     SELECT @ORDID=ORDID FROM ORD WHERE ORDNUMBER = @ORDERNUMBER
	 SELECT @ALLOCATION = LTRIM(RTRIM(ALLOCATION)) FROM ORDITEMS WHERE ORDID=@ORDID
	 SET @CONTRACT = SPACE(25) 
	 IF @ALLOCATION ='Balance Sheet'   
	   BEGIN
	      SET @FIRSTSTOCKID = 0
		  SET @STORENAME = ''
		  SET @CONTRACTNO = ''
		  SET @CONTRACT = space(35) 
	      SELECT TOP 1  @FIRSTSTOCKID = STOCKID FROM ORDITEMS WHERE ORDID = @ORDID 
		  SELECT @STORENAME = STKSTORE  FROM INVENTORY WHERE STKID = @FIRSTSTOCKID 
		  SELECT @CONTRACTNO = STORECONTNUMBER FROM INVSTORES WHERE STORECODE = @STORENAME 
		  SELECT @CONTRACT = CONTRNAME FROM CONTRACTS WHERE CONTRNUMBER=@CONTRACTNO 
		  UPDATE #TEMP0 SET  PROJECT = @CONTRACT WHERE KEYS = @KEYS
		  UPDATE #TEMP0 SET  SHORTDESCRIPTION = R.SHORTDESCR  FROM REQ R INNER JOIN ORD ON 
		  ORD.REQID = R.REQID AND ORD.ORDID = @ORDID WHERE KEYS = @KEYS 
	   END
     
	 IF @ALLOCATION ='Contracts'   
	   BEGIN
	      SET @CONTRACTNO = ''
		  SET @CONTRACT =  space(35) 
	  	  SELECT @CONTRACTNO = CONTRACTID  FROM ORDITEMS WHERE ORDID = @ORDID 
		  SELECT @CONTRACT = CONTRNAME FROM CONTRACTS WHERE contrid=@CONTRACTNO 
		  UPDATE #TEMP0 SET  PROJECT = @CONTRACT WHERE KEYS = @KEYS
		  UPDATE #TEMP0 SET  SHORTDESCRIPTION = R.SHORTDESCR  FROM REQ R INNER JOIN ORD ON 
		  ORD.REQID = R.REQID AND ORD.ORDID = @ORDID WHERE KEYS=@KEYS
	   END
	  SET @CONTRACT = SPACE(25)
	 FETCH NEXT FROM STORES INTO @KEYS, @ORDERNUMBER 

  END 
  CLOSE STORES
  DEALLOCATE STORES 

  ALTER TABLE #TEMP0 ADD ADDRESS1 VARCHAR(100)
  ALTER TABLE #TEMP0 ADD ADDRESS2 VARCHAR(100) 
  ALTER TABLE #TEMP0 ADD ADDRESS3 VARCHAR(100)
  ALTER TABLE #TEMP0 ADD PIN      VARCHAR(10)
  UPDATE #TEMP0 SET PROJECT = SPACE(25) WHERE DEBIT>0 
 

  SELECT DISTINCT ORGID,PROJECT  INTO #CONTRACT  FROM #TEMP0  WHERE PROJECT<>''
  UPDATE #CONTRACT SET PROJECT = B.BORGNAME FROM BORGS B INNER JOIN #CONTRACT ON #CONTRACT.ORGID=B.BORGID 

  UPDATE #TEMP0 SET PROJECT  = C.PROJECT FROM #CONTRACT  C INNER JOIN #TEMP0 ON #TEMP0.ORGID=C.ORGID 
   select * from #temp0 
  UPDATE #TEMP0 SET CREDITORNAME = CR.CREDNAME FROM CREDITORS CR INNER JOIN #TEMP0 ON #TEMP0.CREDNO=CR.CredNumber 
  UPDATE #TEMP0 SET ADDRESS1 = CR.CredAddress1 FROM CREDITORS CR INNER JOIN #TEMP0 ON #TEMP0.CREDNO=CR.CredNumber 
  UPDATE #TEMP0 SET ADDRESS2 = CR.CredAddress2 FROM CREDITORS CR INNER JOIN #TEMP0 ON #TEMP0.CREDNO=CR.CredNumber 
  UPDATE #TEMP0 SET ADDRESS3 = CR.CredAddress3 FROM CREDITORS CR INNER JOIN #TEMP0 ON #TEMP0.CREDNO=CR.CredNumber 
  UPDATE #TEMP0 SET PIN      = CR.CredPCode    FROM CREDITORS CR INNER JOIN #TEMP0 ON #TEMP0.CREDNO=CR.CredNumber 

  ALTER TABLE #TEMP0 ADD  BORGNAME VARCHAR(100) 
  UPDATE #TEMP0 SET BORGNAME  = B.BORGNAME FROM BORGS B INNER JOIN #TEMP0 ON #TEMP0.ORGID=B.BORGID 
  ALTER TABLE #TEMP0 ADD FROMPERIOD VARCHAR(20)
  ALTER TABLE #TEMP0 ADD TOPERIOD   VARCHAR(20)
 
  UPDATE #TEMP0 SET FROMPERIOD = (SELECT PERIODDESC FROM PERIODMASTER WHERE PERIODID = @FROMPERIOD) 
  UPDATE #TEMP0 SET FROMPERIOD = 'Opening Balance' WHERE @FROMPERIOD=0
  UPDATE #TEMP0 SET TOPERIOD =   (SELECT PERIODDESC FROM PERIODMASTER WHERE PERIODID = @TOPERIOD)

  ALTER TABLE #TEMP0 ADD FINYEAR CHAR(4)
  UPDATE #TEMP0 SET FINYEAR=@FINYEAR

  ALTER TABLE #TEMP0 ADD BORGID INT
  UPDATE #TEMP0 SET BORGID= @BORGID

  ALTER TABLE #TEMP0 ADD CREDITORCONTROL VARCHAR(10)
  UPDATE #TEMP0 SET CREDITORCONTROL = @CREDITORCONTROL
  --UPDATE #TEMP0 SET PDATE=@TRANSSTARTDATE WHERE INDEXCODE=1 

  ALTER TABLE #TEMP0 ADD MONTHNAMES VARCHAR(20)
  ALTER TABLE #TEMP0 ADD MONTHID    INT
  UPDATE #TEMP0 SET MONTHNAMES = datename(month, PDATE)
  UPDATE #TEMP0 SET MONTHID = PM.PERIODID FROM PERIODMASTER PM INNER JOIN #TEMP0 ON #TEMP0.MONTHNAMES = PM.PERIODDESC 

  UPDATE #TEMP0 SET SHORTDESCRIPTION = SPACE(20) WHERE LEFT(BATCHREF,3)<>'DEL'
  UPDATE #TEMP0 SET SHORTDESCRIPTION = SPACE(20) WHERE INDEXCODE= 1
 
  SELECT T.TRANGRP,R.LEDGERCODE INTO #TEMP88 FROM #TEMP0 T INNER JOIN TRANSACTIONS R  ON T.TRANGRP=R.TRANGRP 
         WHERE T.TRANGRP>0 AND R.LEDGERCODE IN (SELECT BANKLEDGER FROM BANKS) 
  ALTER TABLE #TEMP88 ADD BANKNAME VARCHAR(50)
  
  UPDATE #TEMP88 SET BANKNAME =BANKS.BANKNAME FROM BANKS INNER JOIN #TEMP88 ON #TEMP88.LEDGERCODE = BANKS.BANKLEDGER
  UPDATE #TEMP0 SET BANKNAME = #TEMP88.BANKNAME FROM #TEMP88 INNER JOIN #TEMP0 ON #TEMP0.TRANGRP = #TEMP88.TRANGRP  WHERE  LEFT(#TEMP0.BATCHREF,3)='CBC'
  SELECT * FROM #TEMP0 
    
  SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )*1000)

  SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
  SELECT @FILENAME 
  SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP0   ORDER BY CREDNO,INDEXCODE,PERIOD,PDATE '

  EXEC(@SQL)

  RETURN @FILEID
 