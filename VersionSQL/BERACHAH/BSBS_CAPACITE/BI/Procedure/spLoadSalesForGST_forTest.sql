/****** Object:  Procedure [BI].[spLoadSalesForGST_forTest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spLoadSalesForGST_forTest]
as
 
 

DECLARE @WIP VARCHAR(10)
DECLARE @RETAINED VARCHAR(10)
DECLARE @GSTEXPENSE VARCHAR(10)

DECLARE @CREDNO VARCHAR(10) 
DECLARE @GSTCOUNT  INT
DECLARE @CREDITORCOUNT INT
DECLARE @EXPENSECOUNT INT
 
CREATE TABLE #GSTOUTPUT(LEDGERCODE VARCHAR(10)) 
INSERT INTO #GSTOUTPUT VALUES ( '1310028' )
INSERT INTO #GSTOUTPUT VALUES ( '1310029' )
INSERT INTO #GSTOUTPUT VALUES ( '1310030' )
INSERT INTO #GSTOUTPUT VALUES ( '1310031' )
INSERT INTO #GSTOUTPUT VALUES ( '1310032' )
INSERT INTO #GSTOUTPUT VALUES ( '1310033' )
INSERT INTO #GSTOUTPUT VALUES ( '1310034' )
INSERT INTO #GSTOUTPUT VALUES ( '1310035' )
INSERT INTO #GSTOUTPUT VALUES ( '1310036' )

SET @GSTEXPENSE= '5130001'
  

SELECT @WIP= CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME ='Work in Progress' 
SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Retained Income' 



DECLARE @LASTTRANGRP INT
DECLARE @STOCKFROM VARCHAR(10)
DECLARE @STOCKTO   VARCHAR(10)
DECLARE @FAFROM    VARCHAR(10)
DECLARE @FATO      VARCHAR(10)
DECLARE @CREDITORCODE VARCHAR(10)
DECLARE @TRANSFROM INT
DECLARE @TRANSEND  INT
DECLARE @TRANGRP INT
DECLARE @DEBTORCODE_FROM VARCHAR(10)
DECLARE @DEBTORCODE_TO VARCHAR(10)

DECLARE @CGSTPERC DECIMAL(15,2)
DECLARE @CGSTAMOUNT DECIMAL(15,2)

DECLARE @SGSTPERC DECIMAL(15,2)
DECLARE @SGSTAMOUNT DECIMAL(15,2)

DECLARE @IGSTPERC DECIMAL(15,2)
DECLARE @IGSTAMOUNT DECIMAL(15,2)

DECLARE @CESSPERC DECIMAL(15,2)
DECLARE @CESSAMOUNT DECIMAL(15,2)

DECLARE @TAXABLEAMOUNT DECIMAL(15,2)

DECLARE @SUPPLIERNAME VARCHAR(90)
DECLARE @SUPPLIERADDRESS VARCHAR(80)
DECLARE @SUPPLIERGSTN VARCHAR(15)
DECLARE @STATEOFSUPPLY CHAR(2)
DECLARE @SUPPLIERCITY  VARCHAR(40)
DECLARE @SUPPLIERPROVINCE INT 
DECLARE @STATECODE CHAR(2)

DECLARE @ORGGSTN  VARCHAR(15)

DECLARE @GRN VARCHAR(50)
DECLARE @GRNQTY DECIMAL(15,2) 
DECLARE @GRNDATE DATETIME
DECLARE @GRNAMOUNT DECIMAL(15,2)

DECLARE @ORGID INT 
DECLARE @SUPPLIERCODE VARCHAR(10)
DECLARE @INDEXCOUNTER INT
DECLARE @TRANSID  INT
DECLARE @LINECOUNT INT 
DECLARE @LEDGERALLOC VARCHAR(15)
DECLARE @LEDGERCODE VARCHAR(10)
DECLARE @ITEMCOUNT INT 
DECLARE @TAXAMOUNT DECIMAL(18,2) 
DECLARE @TRANSACTIONORG INT 
DECLARE @NARRATION VARCHAR(255)
DECLARE @GSTLEDGERS INT 
DECLARE @GSTEXPENSECOUNT DECIMAL(18,2) 
DECLARE @CONTRA INT

DECLARE @CRILEDGERCODE VARCHAR(10)
DECLARE @CRIINVOICEDATE DATETIME 
DECLARE @CBCRECEIVEDATE DATETIME 
DECLARE @CBCTRANSID INT
DECLARE @CBCLEDGERCODE VARCHAR(15)
DECLARE @CBDRECEIVEDATE DATETIME 
DECLARE @CBDTRANSID INT
DECLARE @CBDLEDGERCODE VARCHAR(15)

SELECT @STOCKFROM=CONTROLFROMGL , @STOCKTO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Stock' 
SELECT @FAFROM =CONTROLFROMGL , @FATO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Fixed Asset' 
SELECT @CREDITORCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors' 
SELECT @DEBTORCODE_FROM = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Debtors' 
SELECT @DEBTORCODE_TO = CONTROLTOGL FROM  CONTROLCODES WHERE CONTROLNAME='Debtors' 

SELECT ICGLCODE INTO #TEMPICLA  FROM BORGS  WHERE BORGID NOT IN (SELECT BORGID FROM BORGS WHERE ICGLCODE IS NULL ) 
INSERT INTO #TEMPICLA VALUES (@WIP)
INSERT INTO #TEMPICLA VALUES (@RETAINED) 
 

 
 

 
 

 
 
 
 
 
 
 


 
 

 
-- SALES 



CREATE TABLE #DTITEMP(LINECOUNT INT PRIMARY KEY , ORGID INT,  YEAR INT,PERIOD INT,PDATE DATE,INVOICEDATE DATE,  
BATCHREF VARCHAR(15), TRANSREF VARCHAR(25), CREDNO VARCHAR(15), TRANGRP INT,TRANSID INT,LEDGERCODE VARCHAR(15),DESCRIPTION VARCHAR(300),DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),
OUTPUTCGST DECIMAL(18,2),OUTPUTSGST DECIMAL(18,2),OUTPUTIGST DECIMAL(18,2),INPUTRCMCGST DECIMAL(18,2),INPUTRCMSGST DECIMAL(18,2),INPUTRCMIGST DECIMAL(18,2),
OUTPUTRCMCGST DECIMAL(18,2),OUTPUTRCMSGST DECIMAL(18,2),OUTPUTRCMIGST DECIMAL(18,2) )

SET @ITEMCOUNT = 0  



DECLARE DTITRANGRP  CURSOR FOR 
SELECT DISTINCT TRANGRP FROM TRANSACTIONS WHERE YEAR>=2018 AND PERIOD>3 AND LEFT(TRANSTYPE,3)='DTI' 
  AND LEDGERCODE IN (SELECT LEDGERCODE FROM #GSTOUTPUT)   
  

OPEN DTITRANGRP 
FETCH NEXT FROM DTITRANGRP INTO @TRANGRP 

WHILE @@FETCH_STATUS=0
BEGIN
   
   
  CREATE TABLE #TEMPDTI(LINEINDEX INT PRIMARY  KEY IDENTITY(1,1), TRANSID  INT ) 
  DELETE FROM #TEMPDTI
  INSERT INTO #TEMPDTI
  SELECT TRANSID FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP AND LEDGERCODE NOT IN(SELECT ICGLCODE FROM #TEMPICLA) ORDER BY TRANSID 
  SELECT  @LINECOUNT = COUNT(*) FROM #TEMPDTI
  SET @INDEXCOUNTER = 1
  WHILE @INDEXCOUNTER<=@LINECOUNT
  BEGIN                                                                                                                                                                                                                                                       
 
    SELECT @TRANSID = TRANSID FROM #TEMPDTI   WHERE LINEINDEX=@INDEXCOUNTER 
	SELECT @LEDGERCODE = LEDGERCODE, @TAXAMOUNT = (DEBIT-CREDIT),@NARRATION = DESCRIPTION ,@LEDGERALLOC = ALLOCATION 
	FROM TRANSACTIONS WHERE TRANSID =  (SELECT TRANSID FROM #TEMPDTI WHERE LINEINDEX = @INDEXCOUNTER )   
	 
	IF  ((@NARRATION LIKE 'Total Gross Billing%') OR (@NARRATION LIKE 'Total Work Done%' ) OR ( @LEDGERCODE IN ( '2541000','2541001','2541002',	'4010000'  )  )  )                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	BEGIN 
	  SET @ITEMCOUNT = @ITEMCOUNT + 1
	  INSERT INTO #DTITEMP(LINECOUNT,ORGID,YEAR,PERIOD,PDATE,BATCHREF,TRANSREF,CREDNO,TRANGRP,TRANSID, LEDGERCODE,DESCRIPTION,DEBIT,CREDIT,INVOICEDATE)
	  SELECT @ITEMCOUNT,ORGID,YEAR,PERIOD,PDATE,BATCHREF,TRANSREF,CREDNO,TRANGRP,TRANSID, LEDGERCODE,DESCRIPTION,DEBIT,CREDIT,PDATE  FROM TRANSACTIONS WHERE TRANSID = @TRANSID
	END 
    IF  @LEDGERCODE = '1310028'    UPDATE #DTITEMP SET OUTPUTCGST=    (@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT 
    IF  @LEDGERCODE = '1310029'    UPDATE #DTITEMP SET OUTPUTSGST=    (@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT
    IF  @LEDGERCODE = '1310030'    UPDATE #DTITEMP SET OUTPUTIGST=    (@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT 
    IF  @LEDGERCODE = '1310031'    UPDATE #DTITEMP SET INPUTRCMCGST=  @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310032'    UPDATE #DTITEMP SET INPUTRCMSGST=  @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310033'    UPDATE #DTITEMP SET INPUTRCMIGST=  @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310034'    UPDATE #DTITEMP SET OUTPUTRCMCGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310035'    UPDATE #DTITEMP SET OUTPUTRCMSGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
    SET @INDEXCOUNTER = @INDEXCOUNTER + 1
  END
  DROP TABLE #TEMPDTI
  FETCH NEXT FROM DTITRANGRP INTO @TRANGRP 
END

CLOSE DTITRANGRP
DEALLOCATE   DTITRANGRP 

ALTER TABLE #DTITEMP ADD CGSTPERCENTAGE DECIMAL(18,2)
ALTER TABLE #DTITEMP ADD SGSTPERCENTAGE DECIMAL(18,2)
ALTER TABLE #DTITEMP ADD IGSTPERCENTAGE DECIMAL(18,2)
UPDATE #DTITEMP SET CGSTPERCENTAGE =0
UPDATE #DTITEMP SET SGSTPERCENTAGE =0
UPDATE #DTITEMP SET IGSTPERCENTAGE =0
UPDATE #DTITEMP SET OUTPUTCGST=0 WHERE OUTPUTCGST IS NULL
UPDATE #DTITEMP SET OUTPUTSGST=0 WHERE OUTPUTSGST IS NULL
UPDATE #DTITEMP SET OUTPUTIGST=0 WHERE OUTPUTIGST IS NULL
UPDATE #DTITEMP SET INPUTRCMCGST=0 WHERE INPUTRCMCGST IS NULL
UPDATE #DTITEMP SET INPUTRCMSGST=0 WHERE INPUTRCMSGST IS NULL
UPDATE #DTITEMP SET INPUTRCMIGST=0 WHERE INPUTRCMIGST IS NULL
UPDATE #DTITEMP SET OUTPUTRCMCGST=0 WHERE OUTPUTRCMCGST IS NULL
UPDATE #DTITEMP SET OUTPUTRCMSGST=0 WHERE OUTPUTRCMSGST IS NULL
UPDATE #DTITEMP SET OUTPUTRCMIGST=0 WHERE OUTPUTRCMIGST IS NULL

UPDATE #DTITEMP SET CGSTPERCENTAGE = ROUND( ( (OUTPUTCGST)/(DEBIT-CREDIT) ) * 100, 2 ) WHERE OUTPUTCGST<>0 
UPDATE #DTITEMP SET SGSTPERCENTAGE = ROUND( ( (OUTPUTSGST)/(DEBIT-CREDIT) ) * 100 ,2 ) WHERE OUTPUTSGST<>0 
UPDATE #DTITEMP SET IGSTPERCENTAGE = ROUND( ( (OUTPUTIGST)/(DEBIT-CREDIT) ) * 100, 2 ) WHERE OUTPUTIGST<>0 

UPDATE #DTITEMP SET CGSTPERCENTAGE = ROUND( ( (INPUTRCMCGST)/(DEBIT-CREDIT) ) * 100, 2 ) WHERE INPUTRCMCGST<>0 
UPDATE #DTITEMP SET SGSTPERCENTAGE = ROUND( ( (INPUTRCMSGST)/(DEBIT-CREDIT) ) * 100 ,2 ) WHERE INPUTRCMSGST<>0 
UPDATE #DTITEMP SET IGSTPERCENTAGE = ROUND( ( (INPUTRCMIGST)/(DEBIT-CREDIT) ) * 100, 2 ) WHERE INPUTRCMIGST<>0 

 
UPDATE  #DTITEMP SET CGSTPERCENTAGE = 6.0 WHERE CGSTPERCENTAGE BETWEEN 5.5 AND 6.9
UPDATE  #DTITEMP SET CGSTPERCENTAGE = 9.0 WHERE CGSTPERCENTAGE BETWEEN 7 AND 11
UPDATE  #DTITEMP SET SGSTPERCENTAGE = 9.0 WHERE SGSTPERCENTAGE BETWEEN 7 AND 11
UPDATE  #DTITEMP SET IGSTPERCENTAGE = 18.0 WHERE IGSTPERCENTAGE BETWEEN 17 AND 19
UPDATE  #DTITEMP SET CGSTPERCENTAGE = 14.0 WHERE CGSTPERCENTAGE BETWEEN 13 AND 14
UPDATE  #DTITEMP SET SGSTPERCENTAGE = 14.0 WHERE SGSTPERCENTAGE BETWEEN 13 AND 14
 

SELECT * FROM #DTITEMP 

DELETE FROM #DTITEMP WHERE  ((DEBIT=0) AND (CREDIT=0) AND  (OUTPUTCGST=0) AND (OUTPUTSGST=0) AND (OUTPUTIGST=0) AND (INPUTRCMCGST=0) AND (INPUTRCMSGST=0) AND (INPUTRCMIGST=0) )

UPDATE #DTITEMP SET DESCRIPTION =''

SELECT * FROM #DTITEMP 
 