/****** Object:  Procedure [BI].[spGSTSales]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGSTSales](@FINYEAR INT,@FROMPERIOD INT,@TOPERIOD INT,@BORGS ListOrgIDS ReadOnly, @CILGSTIN  ListCILGSTIN ReadOnly, @DOCType ListDocType ReadOnly, @GSTType LisGSTType ReadOnly )
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
  BIS.FINYEAR,BIS.PERIODNAME,
  BIS.BORGNAME,BIS.CILGSTIN,
  BIS.DOCTYPE,BIS.GSTTYPE,
  BIS.BATCHREF,BIS.INVOICENUMBER,BIS.INVOICEDATE,BIS.TRANSACTIONDATE,
  BIS.SUPPCODE,BIS.SUPPLIERNAME,BIS.SUPPLIERGSTN,BIS.SUPPLIERCITYNAME,
  BIS.LEDGERCODE,BIS.LEDGERNAME,
  BIS.ITEM,BIS.QTY,BIS.UOM,BIS.RATE,
  BIS.TAXABLE_VALUE AMOUNT,
  BIS.CGST_RATE CGSTRATE,BIS.SGST_RATE SGSTRATE,BIS.IGST_RATE IGSTRATE ,
  BIS.CGST_AMOUNT CGST,BIS.SGST_AMOUNT SGST,BIS.IGST_AMOUNT IGST,
  BIS.CGST_INPUT_RCM_AMOUNT  CGSTRCM_I, BIS.SGST_INPUT_RCM_AMOUNT  SGSTRCM_I,BIS.IGST_INPUT_RCM_AMOUNT  IGSTRCM_I,
  BIS.CGST_OUTPUT_RCM_AMOUNT CGSTRCM_O, BIS.SGST_OUTPUT_RCM_AMOUNT SGSTRCM_O,BIS.IGST_OUTPUT_RCM_AMOUNT IGSTRCM_O,
  BIS.GST_EXPENSE GGSTEXPENSE,EIV.ACKNUMBER,EIV.ACKDATE,EIV.IRN,TRANGRP 
FROM 
  BI.SALESHISTORY BIS
LEFT OUTER  JOIN EI.EINVOICE EIV ON BIS.TRANGRP = EIV.TRANSGROUP
WHERE 
  ORGID IN (SELECT ORGID FROM #BORGS ) AND 
  TRANSTYPE IN (SELECT DOCTYPE FROM #DOCTYPE )  AND 
  CILGSTIN IN (SELECT CILGSTIN FROM #CILGSTIN ) AND 
  GSTTYPE IN (SELECT GSTTYPE FROM #GSTTYPE ) AND
  FINYEAR = @FINYEAR AND 
  PERIOD BETWEEN @FROMPERIOD AND @TOPERIOD 
ORDER BY 
  FINYEAR,PERIOD, ORGID, TRANSTYPE, CILGSTIN, GSTTYPE 