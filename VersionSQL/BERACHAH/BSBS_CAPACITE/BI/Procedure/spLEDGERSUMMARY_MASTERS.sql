/****** Object:  Procedure [BI].[spLEDGERSUMMARY_MASTERS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BI].[spLEDGERSUMMARY_MASTERS](@LISTORGIDS  LISTORGIDS READONLY,@LEDGERCODE VARCHAR(10),@PARTYCODE VARCHAR(10),@FROMYEAR INT ,@FROMPERIOD INT ,@TOYEAR INT,@TOPERIOD INT )  
AS

DECLARE @FIRSTDATE DATETIME
DECLARE @WHICHYEAR INT 
DECLARE @WHICHMONTH INT
DECLARE @WHICHDAY INT

IF @FROMPERIOD >=10 AND @FROMPERIOD<=12 
 BEGIN
   SET @WHICHYEAR = @FROMYEAR
   SET @WHICHMONTH = @FROMPERIOD-9
 END
ELSE
 BEGIN
   SET @WHICHYEAR = @FROMYEAR-1
   SET @WHICHMONTH = @FROMPERIOD+3
 END 

SET @WHICHDAY = 1

SELECT @FIRSTDATE = DATEFROMPARTS(@WHICHYEAR,@WHICHMONTH,@WHICHDAY)



 
 
DECLARE @PARTYNAME VARCHAR(255)
DECLARE @REPORTPERIOD VARCHAR(255)

SELECT @PARTYNAME = CREDNAME FROM CREDITORS WHERE CREDNUMBER=@PARTYCODE AND @LEDGERCODE='1315000' 
SELECT @PARTYNAME = SUBNAME  FROM SUBCONTRACTORS WHERE SUBNUMBER = @PARTYCODE AND @LEDGERCODE = '1320000' 
SELECT @PARTYNAME = DEBTNAME FROM DEBTORS WHERE  DEBTNUMBER = @PARTYCODE AND @LEDGERCODE  BETWEEN  '2540000'  AND '2540002' 

DECLARE @FROMMONTH VARCHAR(255)
DECLARE @TOMONTH VARCHAR(255)

SELECT @FROMMONTH = PERIODDESC FROM PERIODMASTER WHERE PERIODID=@FROMPERIOD
SELECT @TOMONTH = PERIODDESC FROM PERIODMASTER WHERE PERIODID = @TOPERIOD 

SET @REPORTPERIOD = 'From ' +LTRIM(RTRIM(@FROMMONTH)) + ' - ' + LTRIM(RTRIM(STR(@FROMYEAR))) + ' To '  + LTRIM(RTRIM(@TOMONTH)) + ' - ' + LTRIM(RTRIM(STR(@TOYEAR))) 



DECLARE @BANKSTART VARCHAR(250)
DECLARE @BANKEND VARCHAR(250)
DECLARE @CASHSTART VARCHAR(250)
DECLARE @CASHEND VARCHAR(250)
SELECT @BANKSTART=CONTROLFROMGL ,@BANKEND = CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Bank'
SELECT @CASHSTART=CONTROLFROMGL ,@CASHEND = CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Petty Cash'

CREATE TABLE #TRANSACTIONS(TRANSINDEX  INT PRIMARY KEY IDENTITY(1,1),TRANGRP INT,TRANSTYPE VARCHAR(50), ORGID INT,TRANSACTIONDATE DATETIME,INVOICEDATE DATETIME,INVOICENUMBER VARCHAR(125),CHEQUENUMBER VARCHAR(125), NARRATION VARCHAR(500), DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),CURRENCY VARCHAR(15), HOMECURRENCY DECIMAL(18,2) )
CREATE TABLE #TRANSFINAL(TRANSINDEX  INT PRIMARY KEY  ,TRANGRP INT,TRANSTYPE VARCHAR(50), ORGID INT,TRANSACTIONDATE DATETIME,INVOICEDATE DATETIME,INVOICENUMBER VARCHAR(125),CHEQUENUMBER VARCHAR(125), NARRATION VARCHAR(500), DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),CURRENCY VARCHAR(15), HOMECURRENCY DECIMAL(18,2))


CREATE TABLE #BANKS(LEDGERCODE VARCHAR(250))
INSERT INTO #BANKS 
SELECT LEDGERCODE FROM LEDGERCODES WHERE LEDGERCODE BETWEEN @BANKSTART AND @BANKEND AND LEDGERSUMMARY=0
INSERT INTO #BANKS 
SELECT LEDGERCODE FROM LEDGERCODES WHERE LEDGERCODE BETWEEN @CASHSTART AND @CASHEND AND LEDGERSUMMARY=0
DELETE FROM #BANKS WHERE LEDGERCODE IS NULL

CREATE TABLE #ORGS(ORGID INT)
INSERT INTO #ORGS   
SELECT ORGID  FROM @LISTORGIDS
DELETE FROM #ORGS WHERE ORGID IS NULL

 


--SELECT * FROM #ORGS 


DECLARE @TRANGRP INT
DECLARE @TRANSTYPE VARCHAR(255) 
DECLARE @STOCKLEDGERCODE VARCHAR(255)
DECLARE @ITEMTYPE VARCHAR(255)
DECLARE @TRANSID INT
DECLARE @NARRATION VARCHAR(255) 
DECLARE @TRANSINDEX INT 
DECLARE @TRANSDATE DATETIME
DECLARE @INVOICEDATE DATETIME
DECLARE @INVOICENUMBER VARCHAR(255)
DECLARE @DEBIT DECIMAL(18,2)
DECLARE @CREDIT DECIMAL(18,2) 
DECLARE @BANKLEDGRCODE VARCHAR(50)
DECLARE @BANKTRANSID INT
DECLARE @BANKNAME VARCHAR(255)
DECLARE @RECEIVEDDATE DATETIME 
DECLARE @ORGID INT 
DECLARE @EXPENSELEDGERCODE VARCHAR(255)
DECLARE @BYEAR INT
DECLARE @BPERIOD INT
DECLARE @BPDATE DATETIME 
DECLARE @BBATCHREF VARCHAR(255)
DECLARE @BTRANSREF VARCHAR(255)
DECLARE @ORDERNO VARCHAR(255) 



DECLARE @OPENINGBALANCE DECIMAL(18,2)
DECLARE @START_YEAR_BALANCE DECIMAL(18,2)
DECLARE @PREVIOUS_YEARS_BALANCE DECIMAL(18,2)
DECLARE @START_YEAR_OB DECIMAL(18,2)


-- OPENING BALANCE GATHERED
CREATE TABLE #OB(ORGID INT,YEAR INT,PERIOD INT, OB DECIMAL(18,2) )


-- PREVIOUS YEARS OB CONSIDERED IRRESPECTIVE OF PERIODS - IN YEARS 


SELECT ORGID,YEAR,PERIOD,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT 
INTO #OBSCRATCH 
FROM TRANSACTIONS  WHERE LEDGERCODE=@LEDGERCODE AND CREDNO=@PARTYCODE AND YEAR =  @FROMYEAR   AND PERIOD =0 AND 
ORGID IN (SELECT ORGID FROM #ORGS) 

UPDATE #OBSCRATCH 
  SET CREDIT=HOMECURRAMOUNT WHERE CREDIT>0 AND CURRENCY <>'INR' 

UPDATE #OBSCRATCH 
  SET DEBIT=HOMECURRAMOUNT WHERE DEBIT>0 AND CURRENCY<>'INR' 


INSERT INTO #OB 
SELECT ORGID,YEAR,PERIOD,ISNULL(SUM(DEBIT-CREDIT),0) PREVYEARS
FROM #OBSCRATCH  GROUP BY ORGID ,YEAR ,PERIOD 

DELETE FROM #OB WHERE OB=0 

--SELECT * INTO VROB260218 FROM #OB 


-- IN MONTHS 
-- MODIFIED TODAY 19-0-17 ; EARLIER @FROMPERIOD  NOW CHANGE TO @FROMPERIOD-1
IF @FROMPERIOD > 1 
BEGIN 
	INSERT INTO #OB 
	SELECT ORGID,YEAR,PERIOD,ISNULL(SUM(DEBIT-CREDIT),0) FROMYEAR
	FROM TRANSACTIONS WHERE LEDGERCODE=@LEDGERCODE AND CREDNO=@PARTYCODE AND YEAR=@FROMYEAR AND PERIOD BETWEEN 1 AND  @FROMPERIOD-1  AND 
	ORGID IN (SELECT ORGID FROM #ORGS) GROUP BY ORGID,YEAR ,PERIOD 
END 

 

-- ALL THE TRANSACTIONS FOR THE NORTH ZONE OFFICES FOR THE YEAR 2015 AND PRIOR ARE TO BE REMOVED -- WHERE PARENTBORG=23

--- TRANSACTIONS 
 SELECT ORGID,YEAR,PERIOD,TRANGRP 
 INTO #TRANSSUMMARY
 FROM TRANSACTIONS 
 WHERE LEDGERCODE=@LEDGERCODE AND CREDNO=@PARTYCODE AND YEAR BETWEEN @FROMYEAR AND @TOYEAR AND PERIOD <>0

 DELETE FROM #TRANSSUMMARY WHERE ORGID NOT IN (SELECT ORGID FROM #ORGS) 
 DELETE FROM #TRANSSUMMARY WHERE YEAR=@FROMYEAR AND PERIOD<@FROMPERIOD 
 DELETE FROM #TRANSSUMMARY WHERE YEAR=@TOYEAR AND PERIOD>@TOPERIOD 
 
 DELETE FROM #TRANSSUMMARY WHERE YEAR<=2015 AND ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG=23) 
 
 DECLARE TRANGRPS CURSOR FOR SELECT DISTINCT TRANGRP FROM #TRANSSUMMARY 
 OPEN TRANGRPS 
 FETCH NEXT FROM TRANGRPS INTO @TRANGRP 

 WHILE @@FETCH_STATUS =0
 BEGIN
   SELECT @TRANSTYPE = LEFT(TRANSTYPE,3) FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND LEDGERCODE=@LEDGERCODE 
   IF @TRANSTYPE='DEL' 
    BEGIN 
 	   SELECT @NARRATION = DESCRIPTION,@ORGID = ORGID,@TRANSDATE = PDATE, @INVOICEDATE =PDATE, @INVOICENUMBER=TRANSREFEXT,@DEBIT=DEBIT,@CREDIT=CREDIT
	          FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND LEDGERCODE=@LEDGERCODE
	   SELECT @TRANSID = MIN(TRANSID) FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
	   SELECT @STOCKLEDGERCODE =BI.fnGetLedgerCode(@TRANSID) 
	   SELECT @ITEMTYPE = LEDGERNAME FROM LEDGERCODES WHERE LEDGERCODE=@STOCKLEDGERCODE 
	   SET @NARRATION = LTRIM(RTRIM(@NARRATION))+ ' (' +LTRIM(RTRIM(@ITEMTYPE))+')'
	   --INSERT INTO #TRANSACTIONS VALUES ( @TRANGRP, 'DEL', @ORGID, @TRANSDATE, @INVOICEDATE, @INVOICENUMBER,SPACE(10),@NARRATION,@DEBIT,@CREDIT )
	   INSERT INTO #TRANSACTIONS 
	   SELECT TRANGRP,'DEL',ORGID,PDATE,PDATE,TRANSREFEXT,SPACE(10),@NARRATION,DEBIT,CREDIT,CURRENCY,HomeCurrAmount FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP 
	   AND LEDGERCODE=@LEDGERCODE 
	   AND CREDNO=@PARTYCODE
	   AND ORGID  IN (SELECT ORGID FROM #ORGS) 
	END 

    IF @TRANSTYPE='SCI' 
    BEGIN 
 	   SELECT @NARRATION = DESCRIPTION,@ORGID = ORGID,@TRANSDATE = PDATE, @INVOICEDATE =PDATE, @INVOICENUMBER=TRANSREFEXT,@DEBIT=DEBIT,@CREDIT=CREDIT,@ORDERNO=ORDERNO 
	          FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND LEDGERCODE=@LEDGERCODE
	   SELECT @EXPENSELEDGERCODE  = LEDGERCODE FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND ALLOCATION='Contracts' AND DESCRIPTION  LIKE '%Total Gross Billing%'                                                                                                                                                                                                                                             
	   SELECT @ITEMTYPE = LEDGERNAME FROM LEDGERCODES WHERE LEDGERCODE=@EXPENSELEDGERCODE
	   SET @NARRATION ='WO No: '+  LTRIM(RTRIM(@ORDERNO))+ ' (' +LTRIM(RTRIM(@ITEMTYPE))+')'
	   --INSERT INTO #TRANSACTIONS VALUES ( @TRANGRP, 'SCI', @ORGID, @TRANSDATE, @INVOICEDATE, @INVOICENUMBER,SPACE(10),@NARRATION,@DEBIT,@CREDIT )
	   INSERT INTO #TRANSACTIONS 
	   SELECT TRANGRP,'DEL',ORGID,PDATE,PDATE,TRANSREFEXT,SPACE(10),@NARRATION,DEBIT,CREDIT,CURRENCY,HomeCurrAmount FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP 
	   AND LEDGERCODE=@LEDGERCODE 
	   AND CREDNO=@PARTYCODE
	   AND ORGID  IN (SELECT ORGID FROM #ORGS) 
	END 
   IF @TRANSTYPE IN ('JNL' ,'CRI' ,'BFD' ,'DTI' )
    BEGIN
	  
	  INSERT INTO #TRANSACTIONS
	  SELECT  TRANGRP,TRANSTYPE,ORGID,PDATE,RECEIVEDDATE,TRANSREFEXT,SPACE(10),DESCRIPTION,DEBIT,CREDIT,CURRENCY,HomeCurrAmount  
	  FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
	  AND LEDGERCODE=@LEDGERCODE 
	  AND CREDNO=@PARTYCODE 
	  AND ORGID  IN (SELECT ORGID FROM #ORGS) 
	END
	
	IF @TRANSTYPE IN ('CBC','CBD','PCP','PCR','CRA' ,'CCN','SCP' )
	BEGIN
	   SELECT @BANKLEDGRCODE = LEDGERCODE ,@BANKTRANSID = TRANSID FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND LEDGERCODE IN (SELECT LEDGERCODE FROM #BANKS) 
	   SELECT @BANKNAME =  LTRIM(RTRIM(LEDGERNAME)) FROM LEDGERCODES WHERE LEDGERCODE=@BANKLEDGRCODE
	   SELECT @RECEIVEDDATE = RECEIVEDDATE FROM TRANSACTIONS WHERE TRANSID=@BANKTRANSID

	   INSERT INTO #TRANSACTIONS 
	   SELECT TRANGRP,LEFT(TRANSTYPE,3),ORGID,PDATE,@RECEIVEDDATE,SPACE(10),TRANSREFEXT,LTRIM(RTRIM(@BANKNAME)),DEBIT,CREDIT,CURRENCY,HomeCurrAmount 
	   FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
	   AND LEDGERCODE=@LEDGERCODE 
	   AND CREDNO=@PARTYCODE 
	   AND ORGID  IN (SELECT ORGID FROM #ORGS) 
	   SET @BANKLEDGRCODE =''
	   SET @BANKNAME =''
	   SET @RECEIVEDDATE =''
	END

	IF @TRANSTYPE IN ('REV'  )
	BEGIN
	   SELECT @BYEAR=YEAR, @BPERIOD=PERIOD,@BPDATE=PDATE,@BBATCHREF=BATCHREF,@BTRANSREF=TRANSREFEXT 
	   FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND LEDGERCODE=@LEDGERCODE

	   SELECT @BANKLEDGRCODE = LEDGERCODE ,@BANKTRANSID = TRANSID 
	   FROM TRANSACTIONS WHERE   LEDGERCODE IN (SELECT LEDGERCODE FROM #BANKS) AND YEAR=@BYEAR AND PERIOD=@BPERIOD AND 
	   PDATE=@BPDATE AND BATCHREF=@BBATCHREF AND  TRANSREFEXT=@BTRANSREF 
	   SELECT @BANKNAME = LEDGERNAME FROM LEDGERCODES WHERE LEDGERCODE=@BANKLEDGRCODE
	   SELECT @RECEIVEDDATE = RECEIVEDDATE FROM TRANSACTIONS WHERE TRANSID=@BANKTRANSID

	   INSERT INTO #TRANSACTIONS 
	   SELECT TRANGRP,LEFT(TRANSTYPE,3),ORGID,PDATE,@RECEIVEDDATE,SPACE(10),TRANSREFEXT,LTRIM(RTRIM(DESCRIPTION))+'('+LTRIM(RTRIM(@BANKNAME))+')',DEBIT,CREDIT,CURRENCY,HomeCurrAmount 
	   FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
	   AND LEDGERCODE=@LEDGERCODE 
	   AND CREDNO=@PARTYCODE 
	   AND ORGID  IN (SELECT ORGID FROM #ORGS) 
	   SET @BANKLEDGRCODE =''
	   SET @BANKNAME =''
	   SET @RECEIVEDDATE =''
	END

   FETCH NEXT FROM TRANGRPS INTO @TRANGRP 

 END
 CLOSE TRANGRPS
 DEALLOCATE TRANGRPS

 UPDATE #TRANSACTIONS 
  SET CREDIT=HOMECURRENCY WHERE CREDIT>0 AND CURRENCY <>'INR' 

 UPDATE #TRANSACTIONS 
  SET DEBIT=HOMECURRENCY WHERE DEBIT>0 AND CURRENCY<>'INR' 
 -- COPYING OPENING BALANCE
 -- GETTING THE COMBINED OPENING BALANCE 

 DECLARE @COMBINEDOB DECIMAL(18,2)
 DECLARE @OBDEBIT DECIMAL(18,2)
 DECLARE @OBCREDIT DECIMAL(18,2) 

 DECLARE @LINETOTAL DECIMAL(18,2)
 DECLARE @LINEINDEX  INT
 DECLARE @LINEDEBIT DECIMAL(18,2)
 DECLARE @LINECREDIT DECIMAL(18,2)  
 DECLARE @LINENUMBER INT

 SELECT @COMBINEDOB =ISNULL( SUM(OB) ,0 )  FROM #OB 

 IF @COMBINEDOB >= 0 
  BEGIN
    SET @OBDEBIT=@COMBINEDOB 
	SET @OBCREDIT = 0
  END
 ELSE
  BEGIN
   SET @OBDEBIT = 0
   SET @OBCREDIT = ABS(@COMBINEDOB) 
  END 
 INSERT INTO #TRANSACTIONS(ORGID,TRANSTYPE,TRANSACTIONDATE,NARRATION,DEBIT,CREDIT)
                   SELECT      0,'OB',@FIRSTDATE  ,'OPENING BALANCE',@OBDEBIT,@OBCREDIT 

 

 INSERT INTO #TRANSFINAL 
 SELECT * FROM #TRANSACTIONS ORDER BY TRANSACTIONDATE , ORGID  

 ALTER TABLE #TRANSFINAL ADD LINENUMBER INT 
 ALTER TABLE #TRANSFINAL ADD CLOSINGBALANCE DECIMAL(18,2)
 ALTER TABLE #TRANSFINAL ADD BALANCESYMBOL CHAR(20) 
 
 DECLARE TRANSFINAL CURSOR FOR
 SELECT TRANSINDEX,DEBIT,CREDIT FROM #TRANSFINAL ORDER BY TRANSACTIONDATE , ORGID  

 OPEN TRANSFINAL
 FETCH NEXT FROM TRANSFINAL INTO @LINEINDEX ,@LINEDEBIT,@LINECREDIT 

 SET @LINETOTAL = 0
 SET @LINENUMBER = 0 

 WHILE @@FETCH_STATUS = 0
 BEGIN
    SET @LINETOTAL  = @LINETOTAL + @LINEDEBIT - @LINECREDIT 
	SET @LINENUMBER = @LINENUMBER + 1
	IF @LINETOTAL >= 0 
	     UPDATE #TRANSFINAL SET CLOSINGBALANCE = @LINETOTAL , BALANCESYMBOL = 'Dr' , LINENUMBER = @LINENUMBER WHERE TRANSINDEX = @LINEINDEX 
	ELSE
	     UPDATE #TRANSFINAL SET CLOSINGBALANCE = ABS(@LINETOTAL) , BALANCESYMBOL = 'Cr' ,LINENUMBER = @LINENUMBER   WHERE TRANSINDEX = @LINEINDEX 
    
    FETCH NEXT FROM TRANSFINAL INTO @LINEINDEX ,@LINEDEBIT,@LINECREDIT

 END
 CLOSE TRANSFINAL
 DEALLOCATE TRANSFINAL 

 UPDATE #TRANSFINAL SET ORGID=''  WHERE LINENUMBER = 1 AND TRANSTYPE='OB' 



 ALTER TABLE #TRANSFINAL ADD BORGNAME VARCHAR(200)
 UPDATE #TRANSFINAL SET  BORGNAME =SUBSTRING(B.BORGNAME,8,58) FROM BORGS B INNER JOIN #TRANSFINAL ON #TRANSFINAL.ORGID = B.BORGID 

 ALTER TABLE #TRANSFINAL ADD PARTYNAME VARCHAR(255)
 UPDATE #TRANSFINAL SET PARTYNAME = @PARTYNAME 

 ALTER TABLE #TRANSFINAL ADD REPORTPERIOD VARCHAR(250)
 UPDATE #TRANSFINAL SET REPORTPERIOD=@REPORTPERIOD 

 
 
 UPDATE #TRANSFINAL SET INVOICENUMBER = CHEQUENUMBER WHERE CHEQUENUMBER<>''
 Update #TRANSFINAL SET NARRATION = REPLACE(NARRATION, 'Order Number','PO: ' ) 
 UPDATE #TRANSFINAL SET BORGNAME =LTRIM(RTRIM(UPPER(BORGNAME))), NARRATION=UPPER(NARRATION) 

 SELECT LINENUMBER,BORGNAME,TRANSACTIONDATE,NARRATION,TRANSTYPE,INVOICENUMBER,DEBIT,CREDIT,CLOSINGBALANCE,BALANCESYMBOL,PARTYNAME,REPORTPERIOD  FROM #TRANSFINAL ORDER BY  LINENUMBER 

 