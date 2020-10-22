/****** Object:  Procedure [BI].[VRSALESSCI]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BI.VRSALESSCI
AS

BEGIN
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
DECLARE @WIP VARCHAR(10)
DECLARE @RETAINED VARCHAR(10)
DECLARE @GSTEXPENSE VARCHAR(10)

SELECT @WIP= CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME ='Work in Progress' 
SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Retained Income' 

SELECT @STOCKFROM=CONTROLFROMGL , @STOCKTO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Stock' 
SELECT @FAFROM =CONTROLFROMGL , @FATO=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Fixed Asset' 
SELECT @CREDITORCODE = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors' 
SELECT @DEBTORCODE_FROM = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Debtors' 
SELECT @DEBTORCODE_TO = CONTROLTOGL FROM  CONTROLCODES WHERE CONTROLNAME='Debtors' 

 
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


DECLARE @VATTYPES VARCHAR(15)
DECLARE @TAXPERCENTAGE DECIMAL(18,2)
DECLARE @BORGID INT 
DECLARE @BASEAMOUNT DECIMAL(18,2) 

SELECT ICGLCODE INTO #TEMPICLA  FROM BORGS  WHERE BORGID NOT IN (SELECT BORGID FROM BORGS WHERE ICGLCODE IS NULL ) 
INSERT INTO #TEMPICLA VALUES (@WIP)
INSERT INTO #TEMPICLA VALUES (@RETAINED) 
 
CREATE TABLE #SCITEMP(LINECOUNT INT PRIMARY KEY , ORGID INT,  YEAR INT,PERIOD INT,PDATE DATE,INVOICEDATE DATE,  
BATCHREF VARCHAR(15), TRANSREF VARCHAR(25), CREDNO VARCHAR(15), TRANGRP INT,TRANSID INT,LEDGERCODE VARCHAR(15),DESCRIPTION VARCHAR(300),DEBIT DECIMAL(18,2),CREDIT DECIMAL(18,2),
OUTPUTCGST DECIMAL(18,2),OUTPUTSGST DECIMAL(18,2),OUTPUTIGST DECIMAL(18,2),INPUTRCMCGST DECIMAL(18,2),INPUTRCMSGST DECIMAL(18,2),INPUTRCMIGST DECIMAL(18,2),
OUTPUTRCMCGST DECIMAL(18,2),OUTPUTRCMSGST DECIMAL(18,2),OUTPUTRCMIGST DECIMAL(18,2), VATTYPES VARCHAR(10),TAXABLEVALUE DECIMAL(18,2),TAXPERCENTAGE DECIMAL(18,2)  )

SET @ITEMCOUNT = 0  

--SELECT @LASTTRANGRP = MAX(TRANGRP) FROM BI.SALESHISTORY WHERE TRANSTYPE='SCI' AND 
--SELECT @LASTTRANGRP

DECLARE SCITRANGRP  CURSOR FOR 
SELECT DISTINCT TRANGRP 
FROM TRANSACTIONS WHERE TRANGRP = 1967624


  

OPEN SCITRANGRP 
FETCH NEXT FROM SCITRANGRP INTO @TRANGRP 

WHILE @@FETCH_STATUS=0
BEGIN
  SET @CONTRA=0
  SELECT @CONTRA = COUNT(*) FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP AND LEDGERCODE='1310028' 
  CREATE TABLE #TEMPSCI(LINEINDEX INT PRIMARY  KEY IDENTITY(1,1), TRANSID  INT ) 
  DELETE FROM #TEMPSCI
  INSERT INTO #TEMPSCI 
  SELECT TRANSID FROM TRANSACTIONS WHERE TRANGRP = @TRANGRP AND LEDGERCODE  IN ('1310028','1310029','1310040') ORDER BY TRANSID 
  SELECT  @LINECOUNT = COUNT(*) FROM #TEMPSCI  
  SET @INDEXCOUNTER = 1
  WHILE @INDEXCOUNTER<=@LINECOUNT
  BEGIN
 
    SELECT @TRANSID = TRANSID FROM #TEMPSCI   WHERE LINEINDEX=@INDEXCOUNTER 
	SELECT @LEDGERCODE = LEDGERCODE, @TAXAMOUNT = (DEBIT-CREDIT),@NARRATION = DESCRIPTION ,@LEDGERALLOC = ALLOCATION ,@VATTYPES=VATTYPE ,@BORGID=ORGID 
	FROM TRANSACTIONS WHERE TRANSID = @TRANSID  
	
 
	SET @ITEMCOUNT = @ITEMCOUNT + 1
	INSERT INTO #SCITEMP(LINECOUNT,ORGID,YEAR,PERIOD,PDATE,BATCHREF,TRANSREF,CREDNO,TRANGRP,TRANSID, LEDGERCODE,DESCRIPTION,DEBIT,CREDIT,INVOICEDATE,VATTYPES,TAXABLEVALUE)
	SELECT @ITEMCOUNT,ORGID,YEAR,PERIOD,PDATE,BATCHREF,TRANSREF,CREDNO,TRANGRP,TRANSID, LEDGERCODE,DESCRIPTION,DEBIT,CREDIT,PDATE,VATTYPE,0
    FROM TRANSACTIONS WHERE TRANSID = @TRANSID
    
	
	SELECT @TAXPERCENTAGE = VATPERC FROM VATTYPES WHERE VATID=@VATTYPES  AND BORGID=@BORGID   AND VATGC IN ('G4','G5','G6')
	SELECT @VATTYPES,@BORGID,@TAXPERCENTAGE 


    IF  @LEDGERCODE = '1310028'    UPDATE #SCITEMP SET OUTPUTCGST= ABS(@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT 
    IF  @LEDGERCODE = '1310029'    UPDATE #SCITEMP SET OUTPUTSGST= ABS(@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT
    IF  @LEDGERCODE = '1310030'    UPDATE #SCITEMP SET OUTPUTIGST= ABS(@TAXAMOUNT) WHERE LINECOUNT=@ITEMCOUNT 
    IF  @LEDGERCODE = '1310031'    UPDATE #SCITEMP SET INPUTRCMCGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310032'    UPDATE #SCITEMP SET INPUTRCMSGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310033'    UPDATE #SCITEMP SET INPUTRCMIGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310034'    UPDATE #SCITEMP SET OUTPUTRCMCGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	IF  @LEDGERCODE = '1310035'    UPDATE #SCITEMP SET OUTPUTRCMSGST= @TAXAMOUNT WHERE LINECOUNT=@ITEMCOUNT
	SET @BASEAMOUNT = ( @TAXAMOUNT * 100 ) / @TAXPERCENTAGE
	UPDATE #SCITEMP SET TAXABLEVALUE = @BASEAMOUNT, TAXPERCENTAGE = @TAXPERCENTAGE  WHERE LINECOUNT=@INDEXCOUNTER 


    SET @INDEXCOUNTER = @INDEXCOUNTER + 1
  END
  DROP TABLE #TEMPSCI
  FETCH NEXT FROM SCITRANGRP INTO @TRANGRP 
END

CLOSE SCITRANGRP
DEALLOCATE   SCITRANGRP 

ALTER TABLE #SCITEMP ADD CGSTPERCENTAGE DECIMAL(18,2)
ALTER TABLE #SCITEMP ADD SGSTPERCENTAGE DECIMAL(18,2)
ALTER TABLE #SCITEMP ADD IGSTPERCENTAGE DECIMAL(18,2)
UPDATE #SCITEMP SET CGSTPERCENTAGE =0
UPDATE #SCITEMP SET SGSTPERCENTAGE =0
UPDATE #SCITEMP SET IGSTPERCENTAGE =0
UPDATE #SCITEMP SET OUTPUTCGST=0 WHERE OUTPUTCGST IS NULL
UPDATE #SCITEMP SET OUTPUTSGST=0 WHERE OUTPUTSGST IS NULL
UPDATE #SCITEMP SET OUTPUTIGST=0 WHERE OUTPUTIGST IS NULL
UPDATE #SCITEMP SET INPUTRCMCGST=0 WHERE INPUTRCMCGST IS NULL
UPDATE #SCITEMP SET INPUTRCMSGST=0 WHERE INPUTRCMSGST IS NULL
UPDATE #SCITEMP SET INPUTRCMIGST=0 WHERE INPUTRCMIGST IS NULL
UPDATE #SCITEMP SET OUTPUTRCMCGST=0 WHERE OUTPUTRCMCGST IS NULL
UPDATE #SCITEMP SET OUTPUTRCMSGST=0 WHERE OUTPUTRCMSGST IS NULL
UPDATE #SCITEMP SET OUTPUTRCMIGST=0 WHERE OUTPUTRCMIGST IS NULL

UPDATE #SCITEMP SET CGSTPERCENTAGE = TAXPERCENTAGE   WHERE OUTPUTCGST<>0 
UPDATE #SCITEMP SET SGSTPERCENTAGE = TAXPERCENTAGE   WHERE OUTPUTSGST<>0 
UPDATE #SCITEMP SET IGSTPERCENTAGE = TAXPERCENTAGE   WHERE OUTPUTIGST<>0 

UPDATE #SCITEMP SET CGSTPERCENTAGE = TAXPERCENTAGE WHERE INPUTRCMCGST<>0 
UPDATE #SCITEMP SET SGSTPERCENTAGE = TAXPERCENTAGE WHERE INPUTRCMSGST<>0 
UPDATE #SCITEMP SET IGSTPERCENTAGE = TAXPERCENTAGE WHERE INPUTRCMIGST<>0 

 
 
 
DELETE FROM #SCITEMP WHERE (OUTPUTCGST=0) AND (OUTPUTSGST=0) AND (OUTPUTIGST=0) AND (INPUTRCMCGST=0) AND (INPUTRCMSGST=0) AND (INPUTRCMIGST=0) 

UPDATE #SCITEMP SET DESCRIPTION =''

SELECT * FROM #SCITEMP 

INSERT INTO BI.SALESHISTORY
(ORGID,FINYEAR,PERIOD,TRANGRP,TRANSID,TRANSTYPE,INVOICENUMBER,TRANSACTIONDATE,SUPPCODE,ITEM,LEDGERCODE,BATCHREF,INVOICEDATE,
TAXABLE_VALUE,CGST_RATE,CGST_AMOUNT,SGST_RATE,SGST_AMOUNT,IGST_RATE,IGST_AMOUNT,CGST_INPUT_RCM_AMOUNT,CGST_OUTPUT_RCM_AMOUNT,
SGST_INPUT_RCM_AMOUNT,SGST_OUTPUT_RCM_AMOUNT,IGST_INPUT_RCM_AMOUNT,IGST_OUTPUT_RCM_AMOUNT)
SELECT
 ORGID,YEAR,PERIOD,TRANGRP,TRANSID,'SCI',TRANSREF,PDATE,CREDNO,DESCRIPTION,LEDGERCODE,BATCHREF,PDATE,
 TAXABLEVALUE,CGSTPERCENTAGE,OUTPUTCGST,SGSTPERCENTAGE,OUTPUTSGST,IGSTPERCENTAGE,OUTPUTIGST,INPUTRCMCGST,OUTPUTRCMCGST,
  INPUTRCMSGST,OUTPUTRCMSGST,INPUTRCMIGST,OUTPUTRCMIGST 
FROM #SCITEMP
 
UPDATE BI.SALESHISTORY SET CGST_RATE =ABS(CGST_RATE),SGST_RATE=ABS(SGST_RATE), IGST_RATE=ABS(IGST_RATE) 
UPDATE BI.SALESHISTORY SET LEDGERNAME = UPPER(L.LEDGERNAME) FROM LEDGERCODES L INNER JOIN BI.SALESHISTORY BIP ON BIP.LEDGERCODE=L.LEDGERCODE 
UPDATE BI.SALESHISTORY SET SUPPLIERCITY =LTRIM(RTRIM(STR(C.PROVINCEID))), SUPPLIERGSTN=C.ISOCERTIFICATION,SUPPLIERNAME=UPPER(C.CREDNAME)
FROM CREDITORS C INNER JOIN BI.SALESHISTORY BIP ON BIP.SUPPCODE=C.CREDNUMBER 
UPDATE BI.SALESHISTORY SET SUPPLIERCITY =LTRIM(RTRIM(STR(S.PROVINCEID))), SUPPLIERGSTN=S.ISOCERTIFICATION,SUPPLIERNAME=UPPER(S.SUBNAME)
FROM SUBCONTRACTORS  S INNER JOIN BI.SALESHISTORY BIP ON BIP.SUPPCODE=S.SUBNUMBER 
UPDATE BI.SALESHISTORY SET SUPPLIERCITY =LTRIM(RTRIM(STR(D.PROVINCEID))), SUPPLIERGSTN=D.ISOCERTIFICATION,SUPPLIERNAME=UPPER(D.DEBTNAME)
FROM DEBTORS D INNER JOIN BI.SALESHISTORY BIP ON BIP.SUPPCODE=D.DEBTNUMBER 
UPDATE BI.SALESHISTORY SET SUPPLIERCITY = UPPER(BIS.SHORTNAME) FROM BI.STATES BIS INNER JOIN BI.SALESHISTORY BIP ON BIP.SUPPLIERCITY =BIS.PROVINCEID 
UPDATE BI.SALESHISTORY SET SUPPLIERCITYNAME = UPPER(BIS.STATENAME) FROM BI.STATES BIS INNER JOIN BI.SALESHISTORY BIP ON BIP.SUPPLIERCITY=BIS.SHORTNAME
UPDATE BI.SALESHISTORY SET CGST_RATE=0 ,CGST_AMOUNT=0  WHERE CGST_RATE IS NULL
UPDATE BI.SALESHISTORY SET SGST_RATE=0, SGST_AMOUNT=0  WHERE SGST_RATE IS NULL
UPDATE BI.SALESHISTORY SET IGST_RATE=0, IGST_AMOUNT=0  WHERE IGST_RATE IS NULL
UPDATE BI.SALESHISTORY SET CGST_INPUT_RCM_AMOUNT=0,CGST_OUTPUT_RCM_AMOUNT=0 WHERE CGST_INPUT_RCM_AMOUNT IS NULL 
UPDATE BI.SALESHISTORY SET SGST_INPUT_RCM_AMOUNT=0,SGST_OUTPUT_RCM_AMOUNT=0 WHERE SGST_INPUT_RCM_AMOUNT IS NULL 
UPDATE BI.SALESHISTORY SET IGST_INPUT_RCM_AMOUNT=0,IGST_OUTPUT_RCM_AMOUNT=0 WHERE IGST_INPUT_RCM_AMOUNT IS NULL 
UPDATE BI.SALESHISTORY SET GST_EXPENSE =0 WHERE GST_EXPENSE IS NULL
UPDATE BI.SALESHISTORY SET UOM='' WHERE UOM IS NULL
UPDATE BI.SALESHISTORY SET QTY=0 WHERE QTY IS NULL
UPDATE BI.SALESHISTORY SET RATE =0 WHERE RATE IS NULL
UPDATE BI.SALESHISTORY SET ITEM= UPPER(ITEM) ,SUPPLIERNAME = UPPER(SUPPLIERNAME),SUPPLIERCITY =UPPER(SUPPLIERCITY),SUPPLIERCITYNAME = UPPER(SUPPLIERCITYNAME) 
UPDATE BI.SALESHISTORY SET ORDERNO ='' WHERE ORDERNO IS NULL
UPDATE BI.SALESHISTORY SET SUPPLIERNAME='',SUPPLIERGSTN='' , SUPPLIERCITY='',SUPPLIERCITYNAME='' WHERE SUPPLIERNAME IS NULL

UPDATE BI.SALESHISTORY SET BORGNAME = B.BORGNAME , CILGSTIN = B.COMPREG FROM BORGS B INNER JOIN BI.SALESHISTORY BIP ON BIP.ORGID=B.BORGID 
UPDATE BI.SALESHISTORY SET DOCTYPE = TRANSTYPE 
UPDATE BI.SALESHISTORY SET GSTTYPE = 'OUTPUT' WHERE ABS(CGST_AMOUNT) > 0 
UPDATE BI.SALESHISTORY SET GSTTYPE = 'OUTPUT' WHERE ABS(IGST_AMOUNT) > 0 
UPDATE BI.SALESHISTORY SET GSTTYPE = 'RCM' WHERE ABS(CGST_INPUT_RCM_AMOUNT) > 0 
UPDATE BI.SALESHISTORY SET GSTTYPE = 'GST EXPENSE' WHERE ABS(GST_EXPENSE) > 0
UPDATE BI.SALESHISTORY SET DOCTYPE='SCI-CONTRA' WHERE TRANSTYPE='SCI' AND CGST_AMOUNT >0 

END