/****** Object:  Procedure [BI].[spLoadPurchasesForGST_2901]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spLoadPurchasesForGST_2901]
as

 
DECLARE @GSTSTART VARCHAR(10)
DECLARE @GSTEND   VARCHAR(10)
DECLARE @WIP VARCHAR(10)
DECLARE @RETAINED VARCHAR(10)
DECLARE @GSTEXPENSE VARCHAR(10)

DECLARE @CREDNO VARCHAR(10) 
DECLARE @GSTCOUNT  INT
DECLARE @CREDITORCOUNT INT
DECLARE @EXPENSECOUNT INT
DECLARE @LASTTRANGRP INT 

CREATE TABLE #GSTINPUT(LEDGERCODE VARCHAR(10)) 
INSERT INTO #GSTINPUT VALUES ( '1310025' )
INSERT INTO #GSTINPUT VALUES ( '1310026' )
INSERT INTO #GSTINPUT VALUES ( '1310027' )
INSERT INTO #GSTINPUT VALUES ( '1310031' )
INSERT INTO #GSTINPUT VALUES ( '1310032' )
INSERT INTO #GSTINPUT VALUES ( '1310033' )
 

  

SELECT @WIP= CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME ='Work in Progress' 
SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Retained Income' 

SET @GSTSTART = '1310025'
SET @GSTEND = '1310035' 
SET @GSTEXPENSE= '5130001'

DECLARE @STOCKFROM VARCHAR(10)
DECLARE @STOCKTO   VARCHAR(10)
DECLARE @FAFROM    VARCHAR(10)
DECLARE @FATO      VARCHAR(10)
DECLARE @CREDITORCODE VARCHAR(10)
DECLARE @TRANSFROM INT
DECLARE @TRANSEND  INT
DECLARE @TRANGRP INT

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

DECLARE @CRILEDGERCODE VARCHAR(10)
DECLARE @CRIINVOICEDATE DATETIME 
DECLARE @CBCRECEIVEDATE DATETIME 
DECLARE @CBCTRANSID INT
DECLARE @CBCLEDGERCODE VARCHAR(15)
DECLARE @CBDRECEIVEDATE DATETIME 
DECLARE @CBDTRANSID INT
DECLARE @CBDLEDGERCODE VARCHAR(15)
DECLARE @INSERTED INT 

DECLARE @PURCHASETOSTOCK INT 


DECLARE @CGSTCOUNT INT
DECLARE @CGSTRATE DECIMAL(18,2)

DECLARE @IGSTCOUNT INT
DECLARE @IGSTRATE DECIMAL(18,2)

DECLARE @RCMCGSTCOUNT INT
DECLARE @RCMCGSTRATE DECIMAL(18,2)

DECLARE @RCMIGSTCOUNT INT
DECLARE @RCMIGSTRATE DECIMAL(18,2)

DECLARE @RCMSGSTAMOUNT DECIMAL(18,2) 

SELECT @STOCKFROM=CONTROLFROMGL , @STOCKTO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Stock' 
SELECT @FAFROM =CONTROLFROMGL , @FATO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Fixed Asset' 
SELECT @CREDITORCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors' 

SELECT ICGLCODE INTO #TEMPICLA  FROM BORGS  WHERE BORGID NOT IN (SELECT BORGID FROM BORGS WHERE ICGLCODE IS NULL ) 
INSERT INTO #TEMPICLA VALUES (@WIP)
INSERT INTO #TEMPICLA VALUES (@RETAINED) 
 

 CREATE TABLE #GSTTRANS (LEDGERCODE VARCHAR(15),PERC DECIMAL(18,2) ) 
CREATE TABLE #TAXAMOUNT (LEDGERCODE VARCHAR(10),TAXAMOUNT DECIMAL(18,2))




CREATE TABLE #CCNTEMP(LINECOUNT INT PRIMARY KEY IDENTITY (1,1) , ORGID INT,  YEAR INT,PERIOD INT,PDATE DATE, INVOICEDATE DATE,
BATCHREF VARCHAR(25), TRANSREF VARCHAR(50), CREDNO VARCHAR(25), TRANGRP INT,TRANSID INT,LEDGERCODE VARCHAR(25),DESCRIPTION VARCHAR(400),
TAXABLEVALUE DECIMAL(18,2),DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),
CGSTRATE DECIMAL(18,2),CGST DECIMAL(18,2),
SGSTRATE DECIMAL(18,2),SGST DECIMAL(18,2),
IGSTRATE DECIMAL(18,2),IGST DECIMAL(18,2),
RCMCGSTRATE DECIMAL(18,2), RCMCGST DECIMAL(18,2),
RCMSGSTRATE DECIMAL(18,2), RCMSGST DECIMAL(18,2),
RCMIGSTRATE DECIMAL(18,2), RCMIGST DECIMAL(18,2)
)

SET @LINECOUNT = 0 
DECLARE CCNTRANGRP CURSOR 
FOR 
SELECT 
  DISTINCT TRANGRP FROM TRANSACTIONS 
  WHERE YEAR>=2018 AND PERIOD>3 AND LEFT(BATCHREF,3)='CCN' AND LEDGERCODE IN (SELECT LEDGERCODE FROM #GSTINPUT) 
  AND TRANGRP NOT IN (SELECT TRANGRP FROM BI.PURCHASEHISTORY WHERE DOCTYPE='CCN') 

 
OPEN CCNTRANGRP 
FETCH NEXT FROM CCNTRANGRP INTO @TRANGRP 

WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @TRANSFROM = MIN(TRANSID), @TRANSEND = MAX(TRANSID) FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
  
  DELETE FROM #TAXAMOUNT 
  INSERT INTO #TAXAMOUNT 
  SELECT LEDGERCODE,SUM(DEBIT-CREDIT) TAXAMOUNT 
  FROM TRANSACTIONS 
  WHERE TRANGRP = @TRANGRP  AND LEDGERCODE IN (SELECT LEDGERCODE FROM #GSTINPUT) GROUP BY LEDGERCODE 

  DELETE FROM #GSTTRANS 
  INSERT INTO #GSTTRANS
  SELECT DISTINCT  LEDGERCODE,PERC    FROM TAXTRANS  WHERE TRANSID BETWEEN @TRANSFROM AND @TRANSEND  
   
  INSERT INTO #CCNTEMP(TRANGRP,  CGST ) 
  SELECT @TRANGRP,   TAXAMOUNT FROM #TAXAMOUNT  WHERE LEDGERCODE='1310025'  
  
  SET @SGSTAMOUNT = 0
  SET @RCMSGSTAMOUNT = 0 

  SELECT @SGSTAMOUNT = TAXAMOUNT FROM #TAXAMOUNT WHERE LEDGERCODE='1310026'  
  UPDATE #CCNTEMP SET SGST = @SGSTAMOUNT  WHERE TRANGRP = @TRANGRP 

  SELECT @CGSTCOUNT = COUNT(*) FROM #GSTTRANS WHERE LEDGERCODE='1310025' 
  IF @CGSTCOUNT = 1
     BEGIN 
	   SELECT @CGSTPERC = PERC FROM #GSTTRANS WHERE LEDGERCODE='1310025' 
	   UPDATE #CCNTEMP SET CGSTRATE = @CGSTPERC,SGSTRATE = @CGSTPERC  WHERE   TRANGRP = @TRANGRP 
	 END

  INSERT INTO #CCNTEMP(TRANGRP, IGST ) 
  SELECT @TRANGRP,   TAXAMOUNT FROM #TAXAMOUNT  WHERE LEDGERCODE='1310027' 
  SELECT @IGSTCOUNT = COUNT(*) FROM #GSTTRANS WHERE LEDGERCODE='1310027' 
  IF @IGSTCOUNT = 1
     BEGIN 
	   SELECT @IGSTPERC = PERC FROM #GSTTRANS WHERE LEDGERCODE='1310027' 
	   UPDATE #CCNTEMP SET IGSTRATE = @IGSTPERC WHERE    TRANGRP = @TRANGRP 
	 END


  INSERT INTO #CCNTEMP(TRANGRP,  RCMCGST ) 
  SELECT @TRANGRP,   TAXAMOUNT FROM #TAXAMOUNT  WHERE LEDGERCODE='1310031'
  SELECT @RCMCGSTCOUNT = COUNT(*) FROM #GSTTRANS WHERE LEDGERCODE='1310031' 
  IF @RCMCGSTCOUNT = 1
     BEGIN 
	   SELECT @RCMCGSTRATE = PERC FROM #GSTTRANS WHERE LEDGERCODE='1310031' 
	   UPDATE #CCNTEMP SET RCMCGSTRATE  = @RCMCGSTRATE, RCMSGSTRATE  = @RCMCGSTRATE  WHERE    TRANGRP = @TRANGRP 
	 END
  SELECT @RCMSGSTAMOUNT = TAXAMOUNT FROM #TAXAMOUNT WHERE LEDGERCODE='1310032'  
  UPDATE #CCNTEMP SET RCMSGST = @RCMSGSTAMOUNT  WHERE TRANGRP = @TRANGRP 

  INSERT INTO #CCNTEMP(TRANGRP ,  RCMIGST ) 
  SELECT @TRANGRP,   TAXAMOUNT FROM #TAXAMOUNT  WHERE LEDGERCODE='1310033'
  SELECT @RCMIGSTCOUNT = COUNT(*) FROM #GSTTRANS WHERE LEDGERCODE='1310033' 
  IF @RCMIGSTCOUNT = 1
     BEGIN 
	   SELECT @RCMIGSTRATE = PERC FROM #GSTTRANS WHERE LEDGERCODE='1310033' 
	   UPDATE #CCNTEMP SET IGSTRATE = @RCMIGSTRATE WHERE    TRANGRP = @TRANGRP 
	 END

  UPDATE  #CCNTEMP 
  SET ORGID=T.ORGID,YEAR=T.YEAR,PERIOD=T.PERIOD,PDATE=T.PDATE,INVOICEDATE=T.RECEIVEDDATE,BATCHREF=T.BATCHREF,TRANSREF =T.TRANSREFEXT,TRANSID=T.TRANSID,
      CREDNO=T.CREDNO, TAXABLEVALUE = (T.CREDIT-T.DEBIT)  FROM TRANSACTIONS T  INNER JOIN #CCNTEMP ON #CCNTEMP.TRANGRP = T.TRANGRP  WHERE  T.LEDGERCODE ='1315000' 

  
  UPDATE #CCNTEMP 
   SET LEDGERCODE = T.LEDGERCODE,DESCRIPTION=T.DESCRIPTION FROM TRANSACTIONS T WHERE #CCNTEMP.TRANGRP = @TRANGRP AND T.TRANSID = @TRANSFROM
  
  UPDATE #CCNTEMP SET  CREDIT=0 WHERE CREDIT IS NULL AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  CGST=0 WHERE  CGST IS NULL AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  SGST=0 WHERE  SGST IS NULL  AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  IGST=0 WHERE  IGST IS NULL  AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  RCMCGST=0 WHERE  RCMCGST IS NULL  AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  RCMSGST=0 WHERE  RCMSGST IS NULL  AND TRANGRP = @TRANGRP 
  UPDATE #CCNTEMP SET  RCMIGST=0 WHERE  RCMIGST IS NULL  AND TRANGRP = @TRANGRP 

 
  FETCH NEXT FROM CCNTRANGRP INTO @TRANGRP 
END


CLOSE CCNTRANGRP
DEALLOCATE CCNTRANGRP

UPDATE #CCNTEMP SET  CREDIT=0 WHERE CREDIT IS NULL 
UPDATE #CCNTEMP SET  CGST=0 WHERE  CGST IS NULL
UPDATE #CCNTEMP SET  SGST=0 WHERE  SGST IS NULL
UPDATE #CCNTEMP SET  IGST=0 WHERE  IGST IS NULL
UPDATE #CCNTEMP SET  RCMCGST=0 WHERE  RCMCGST IS NULL
UPDATE #CCNTEMP SET  RCMSGST=0 WHERE  RCMSGST IS NULL
UPDATE #CCNTEMP SET  RCMIGST=0 WHERE  RCMIGST IS NULL
UPDATE #CCNTEMP SET  RCMCGSTRATE=0 WHERE RCMCGSTRATE IS NULL
UPDATE #CCNTEMP SET  RCMIGSTRATE=0 WHERE RCMIGSTRATE IS NULL


UPDATE #CCNTEMP SET CGSTRATE=RCMCGSTRATE , SGSTRATE=RCMSGSTRATE WHERE RCMCGSTRATE>0 
UPDATE #CCNTEMP SET IGSTRATE = RCMIGSTRATE WHERE RCMIGSTRATE>0 

 SELECT * FROM #CCNTEMP
  


INSERT INTO BI.PURCHASEHISTORY
(ORGID,FINYEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,INVOICENUMBER,TRANSACTIONDATE,SUPPCODE,ITEM,LEDGERCODE,BATCHREF,INVOICEDATE,
TAXABLE_VALUE,CGST_RATE,CGST_AMOUNT,SGST_RATE,SGST_AMOUNT,IGST_RATE,IGST_AMOUNT,CGST_INPUT_RCM_AMOUNT,SGST_INPUT_RCM_AMOUNT,IGST_INPUT_RCM_AMOUNT,DOCTYPE)
SELECT 
 ORGID,YEAR,PERIOD,TRANGRP,TRANSID,'CCN',TRANSREF,PDATE,CREDNO,UPPER(DESCRIPTION),LEDGERCODE,BATCHREF,INVOICEDATE,
 TAXABLEVALUE,CGSTRATE,CGST,SGSTRATE,SGST,IGSTRATE,IGST,RCMCGST,RCMSGST,RCMIGST,'CCN'
FROM #CCNTEMP