/****** Object:  Procedure [BI].[spGSTPurchase]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGSTPurchase](@FINYEAR INT,@FROMPERIOD INT,@TOPERIOD INT,@BORGS ListOrgIDS ReadOnly, @CILGSTIN  ListCILGSTIN ReadOnly, @DOCType ListDocType ReadOnly, @GSTType LisGSTType ReadOnly )
AS

CREATE TABLE #BORGS(ORGID INT)
INSERT INTO #BORGS 
SELECT ORGID  FROM @BORGS
DELETE FROM #BORGS WHERE ORGID IS NULL


CREATE TABLE #CILGSTIN(CILGSTIN VARCHAR(25))
INSERT INTO #CILGSTIN
SELECT CILGSTIN  FROM @CILGSTIN
DELETE FROM #CILGSTIN WHERE CILGSTIN IS NULL


CREATE TABLE #DOCTYPE(DOCTYPE VARCHAR(25))
INSERT INTO #DOCTYPE
SELECT DOCTYPE  FROM @DOCType
DELETE FROM #DOCTYPE WHERE DOCTYPE IS NULL
 

CREATE TABLE #GSTTYPE(GSTTYPE VARCHAR(25))
INSERT INTO #GSTTYPE
SELECT GSTTYPE  FROM @GSTType
DELETE FROM #GSTTYPE WHERE GSTTYPE IS NULL

SELECT 
  FINYEAR,PERIODNAME,
  BORGNAME,CILGSTIN,
  DOCTYPE,GSTTYPE,
  BATCHREF,INVOICENUMBER,INVOICEDATE,TRANSACTIONDATE,
  SUPPCODE,SUPPLIERNAME,SUPPLIERGSTN,SUPPLIERCITYNAME,
  LEDGERCODE,LEDGERNAME,
  ITEM,QTY,UOM,RATE,
  TAXABLE_VALUE AMOUNT,
  CGST_RATE CGSTRATE,SGST_RATE SGSTRATE,IGST_RATE IGSTRATE ,
  CGST_AMOUNT CGST,SGST_AMOUNT SGST, IGST_AMOUNT IGST,
  CGST_INPUT_RCM_AMOUNT  CGSTRCM_I, SGST_INPUT_RCM_AMOUNT  SGSTRCM_I,IGST_INPUT_RCM_AMOUNT  IGSTRCM_I,
  CGST_OUTPUT_RCM_AMOUNT CGSTRCM_O, SGST_OUTPUT_RCM_AMOUNT SGSTRCM_O,IGST_OUTPUT_RCM_AMOUNT IGSTRCM_O,
  GST_EXPENSE GGSTEXPENSE,
  TRANGRP ,
  TRANSID 
FROM 
  BI.PURCHASEHISTORY 
WHERE 
  ORGID IN (SELECT ORGID FROM #BORGS ) AND 
  TRANSTYPE IN (SELECT DOCTYPE FROM #DOCTYPE )  AND 
  CILGSTIN IN (SELECT CILGSTIN FROM #CILGSTIN ) AND 
  GSTTYPE IN (SELECT GSTTYPE FROM #GSTTYPE ) AND
  FINYEAR = @FINYEAR AND 
  PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD 
ORDER BY 
  FINYEAR,PERIOD, ORGID, TRANSTYPE, CILGSTIN, GSTTYPE 