/****** Object:  Procedure [dbo].[VRGSTTEST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE VRGSTTEST
as

--SELECT * INTO BI.VRGT FROM BI.PURCHASEHISTORY WHERE 1=2 
DELETE FROM BI.VRGT
--DELETE FROM BI.PURCHASEHISTORY 
--DBCC CHECKIDENT ("BI.PURCHASEHISTORY",RESEED,0)
 
DECLARE @GSTSTART VARCHAR(10)
DECLARE @GSTEND   VARCHAR(10)
DECLARE @WIP VARCHAR(10)
DECLARE @RETAINED VARCHAR(10)
DECLARE @GSTEXPENSE VARCHAR(10)

DECLARE @CREDNO VARCHAR(10) 
DECLARE @GSTCOUNT  INT
DECLARE @CREDITORCOUNT INT
DECLARE @EXPENSECOUNT INT
 
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


DECLARE @PURCHASETOSTOCK INT 

SELECT @STOCKFROM=CONTROLFROMGL , @STOCKTO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Stock' 
SELECT @FAFROM =CONTROLFROMGL , @FATO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Fixed Asset' 
SELECT @CREDITORCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors' 

SELECT ICGLCODE INTO #TEMPICLA  FROM BORGS  WHERE BORGID NOT IN (SELECT BORGID FROM BORGS WHERE ICGLCODE IS NULL ) 
INSERT INTO #TEMPICLA VALUES (@WIP)
INSERT INTO #TEMPICLA VALUES (@RETAINED) 
 

-- PURCHASE

CREATE TABLE #TEMPTAXTRANS (VATGC VARCHAR(10),PERC DECIMAL(18,2),TAX DECIMAL(18,2),CUMCOST DECIMAL(18,2), CUMTAX DECIMAL(18,2),VATTYPE VARCHAR(10),PROVINCEID INT, TRANSID INT) 

SELECT VATGC,NAME,LEDGERCODE 
INTO #TEMPVATGROUPS 
FROM VATGROUPS WHERE LEFT(VATGC,1)='G' 
 

DECLARE PURTRANGRP CURSOR 
FOR 
SELECT 
  DISTINCT TRANGRP FROM TRANSACTIONS 
  WHERE YEAR>=2018 AND PERIOD>3 AND TRANSTYPE='DEL' AND LEDGERCODE IN (SELECT LEDGERCODE FROM #GSTINPUT)   
 
OPEN PURTRANGRP 
FETCH NEXT FROM PURTRANGRP INTO @TRANGRP 

WHILE @@FETCH_STATUS=0
BEGIN
  SET @GSTLEDGERS=0
  SELECT @GSTLEDGERS = ISNULL( COUNT(LEDGERCODE),0)  FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP AND LEDGERCODE  BETWEEN @GSTSTART AND @GSTEND  
  IF @GSTLEDGERS <>0 
  BEGIN
      SELECT @TRANSFROM = MIN(TRANSID), @TRANSEND = MAX(TRANSID) FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP 
	  SELECT @PURCHASETOSTOCK = ISNULL(COUNT(*) ,0 ) FROM TRANSACTIONS WHERE  TRANGRP=@TRANGRP  AND LEDGERCODE BETWEEN @STOCKFROM AND  @STOCKTO 

	  DELETE FROM #TEMPTAXTRANS
	  INSERT INTO #TEMPTAXTRANS
	  SELECT VATGC,PERC,TAX,CUMCOST,CUMTAX,VATTYPE,PROVINCEIDD ,TRANSID 
	  FROM TAXTRANS 
	  WHERE TRANSID BETWEEN @TRANSFROM  AND @TRANSEND
    
	  IF @PURCHASETOSTOCK >0 
	  BEGIN 
		  INSERT INTO BI.VRGT
		  (ORGID,FINYEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,BATCHREF,ORDERNO,INVOICEDATE,TRANSACTIONDATE,INVOICENUMBER,SUPPCODE,ITEM,QTY,UOM,RATE,LEDGERCODE)
		  SELECT 
		  ORGID,YEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,BATCHREF,ORDERNO,RECEIVEDDATE,PDATE,TRANSREFEXT,CREDNO,UPPER(LEFT(DESCRIPTION,180)),QUANTITY,UPPER(UNIT),RATE,[BI].[fnGetLedgerCode](TRANSID) 
		  FROM TRANSACTIONS  WHERE TRANGRP=@TRANGRP AND LEDGERCODE BETWEEN @STOCKFROM AND @STOCKTO 
	  END 

	  IF @PURCHASETOSTOCK =0 
	  BEGIN 
	      SELECT @TRANGRP 
		  INSERT INTO BI.VRGT
		  (ORGID,FINYEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,BATCHREF,ORDERNO,INVOICEDATE,TRANSACTIONDATE,INVOICENUMBER,SUPPCODE,ITEM,QTY,UOM,RATE,LEDGERCODE)
		  SELECT 
		  ORGID,YEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,BATCHREF,ORDERNO,RECEIVEDDATE,PDATE,TRANSREFEXT,CREDNO,UPPER(LEFT(DESCRIPTION,180)),QUANTITY,UPPER(UNIT),RATE,[BI].[fnGetLedgerCode](TRANSID) 
		  FROM TRANSACTIONS  WHERE TRANGRP=@TRANGRP AND TRANSID = @TRANSFROM
	  END 

	  UPDATE BI.VRGT
	  SET CGST_RATE = TT.PERC ,CGST_AMOUNT = TT.TAX , TAXABLE_VALUE = TT.CUMCOST FROM #TEMPTAXTRANS TT
	  INNER JOIN BI.VRGT PH ON PH.TRANSID = TT.TRANSID  AND  TT.VATGC='G1' 

	  UPDATE BI.VRGT 
	  SET SGST_RATE = TT.PERC , SGST_AMOUNT = TT.TAX , TAXABLE_VALUE = TT.CUMCOST FROM #TEMPTAXTRANS TT
	  INNER JOIN BI.VRGT PH ON PH.TRANSID = TT.TRANSID  AND  TT.VATGC='G2' 


	  UPDATE BI.VRGT
	  SET IGST_RATE = TT.PERC , IGST_AMOUNT = TT.TAX , TAXABLE_VALUE = TT.CUMCOST FROM #TEMPTAXTRANS TT
	  INNER JOIN BI.VRGT PH ON PH.TRANSID = TT.TRANSID  AND TT.VATGC='G3' 
 
  END 

  FETCH NEXT FROM PURTRANGRP INTO @TRANGRP


END


CLOSE PURTRANGRP
DEALLOCATE PURTRANGRP

DELETE FROM BI.VRGT WHERE TAXABLE_VALUE IS NULL AND TRANSTYPE='DEL'

SELECT * FROM BI.VRGT