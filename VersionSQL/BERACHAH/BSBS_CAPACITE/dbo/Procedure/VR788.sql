/****** Object:  Procedure [dbo].[VR788]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[VR788]
AS
DECLARE @COUNTS INT
SET @COUNTS=12775

WHILE  @COUNTS <= 12808
BEGIN
 
  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','INVOICEDATE','Jan 01 2017',-1,GETDATE(),0)
  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','INVOICEAMOUNT',0,-1,GETDATE(),0)
  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','ORDERTYPE',2,-1,GETDATE(),0)

  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','PODATE','Jan 01 2017',-1,GETDATE(),0)

  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','PONUMBER','TRANSFER' ,-1,GETDATE(),0)

  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','SUPPLIERCODE','TRANSFER' ,-1,GETDATE(),0)

  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','SUPPLIERNAME','TRANSFER FROM YOGNUM',-1,GETDATE(),0)

  INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','TAXAMOUNT',0,-1,GETDATE(),0) 











 
--INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','DUTYBENEFITS',0,-1,GETDATE(),0)
--INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','FEREVALUATION',0,-1,GETDATE(),0)
--INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','ORDID',0,-1,GETDATE(),0)
--INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','GRN',SPACE(10),-1,GETDATE(),0)
--INSERT INTO ATTRIBVALUE VALUES (@COUNTS,'ASSETS','INVOICENO','TRANSFER',-1,GETDATE(),0)

SET @COUNTS = @COUNTS + 1
END

 
 