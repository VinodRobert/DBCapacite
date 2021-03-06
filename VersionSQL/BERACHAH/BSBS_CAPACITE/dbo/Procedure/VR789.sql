/****** Object:  Procedure [dbo].[VR789]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[VR789]
AS
 
 
DECLARE @CREDNO VARCHAR(10)
DECLARE @ORDERNO VARCHAR(55)
DECLARE @TRANGRP INT
DECLARE @INVOICEAMOUNT DECIMAL(18,2)
DECLARE @TAXAMOUNT DECIMAL(18,2)
DECLARE @PONUMBER VARCHAR(55)
DECLARE @INVOICENUMBER VARCHAR(10)
DECLARE @INVOICEDATE DATETIME 
DECLARE @ORDERTYPE INT
DECLARE @ASSETID VARCHAR(10)
 
 
--DECLARE INVS CURSOR FOR
--SELECT VALUE,COLKEY FROM ATTRIBVALUE WHERE ATTRIBUTE='INVOICENO' AND VALUE<>'TRANSFER'  

--OPEN INVS
--FETCH NEXT FROM INVS INTO @INVOICENUMBER,@ASSETID 

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    SELECT @INVOICENUMBER,@ASSETID 

--    SELECT  @CREDNO=CREDNO,
--	      	@INVOICEAMOUNT = CREDIT,
--			@TRANGRP = TRANGRP 
--	FROM
--			TRANSACTIONS WHERE TRANSREF=@INVOICENUMBER
--			AND LEDGERCODE='1315000'  AND ORGID IN ( 2, 30, 36 )
--	SELECT @TAXAMOUNT =ISNULL( SUM(DEBIT),0)  FROM TRANSACTIONS WHERE TRANGRP=@TRANGRP AND 
--	LEDGERCODE BETWEEN '1310000'  AND  '1310019' 

--	UPDATE ATTRIBVALUE SET VALUE = @INVOICEAMOUNT WHERE COLKEY=@ASSETID AND ATTRIBUTE='INVOICEAMOUNT' 
--	UPDATE ATTRIBVALUE SET VALUE = @TAXAMOUNT WHERE COLKEY=@ASSETID AND ATTRIBUTE='TAXAMOUNT' 
	 
--	FETCH NEXT FROM INVS INTO @INVOICENUMBER,@ASSETID 
--END 
--CLOSE INVS
--DEALLOCATE INVS

DECLARE @ORDERID INT 
DECLARE @PODATE DATETIME 
DECLARE @SUPPID INT

DECLARE @SUPPCODE VARCHAR(10)
DECLARE @SUPPLIERNAME VARCHAR(200)

DECLARE INVS CURSOR FOR
SELECT VALUE,COLKEY FROM ATTRIBVALUE WHERE ATTRIBUTE='ORDID' AND COLKEY>='12737' 

OPEN INVS
FETCH NEXT FROM INVS INTO @ORDERID,@ASSETID 

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @ORDERID,@ASSETID 

	SELECT @PONUMBER = ORDNUMBER,@PODATE = CREATEDATE,@SUPPID=SUPPID  FROM ORD WHERE ORDID=@ORDERID 
	SELECT @SUPPCODE=SUPPCODE,@SUPPLIERNAME =SUPPNAME FROM SUPPLIERS WHERE SUPPID=@SUPPID 

    SELECT @PONUMBER,@SUPPCODE,@SUPPLIERNAME,@ORDERID,@ASSETID 


	UPDATE ATTRIBVALUE SET VALUE = @PONUMBER WHERE COLKEY=@ASSETID AND ATTRIBUTE='PONUMBER' 
	UPDATE ATTRIBVALUE SET VALUE = @SUPPCODE WHERE COLKEY=@ASSETID AND ATTRIBUTE='SUPPLIERCODE' 
	UPDATE ATTRIBVALUE SET VALUE = @SUPPLIERNAME WHERE COLKEY=@ASSETID AND ATTRIBUTE='SUPPLIERNAME' 

	FETCH NEXT FROM INVS INTO @ORDERID,@ASSETID 
END 
CLOSE INVS
DEALLOCATE INVS