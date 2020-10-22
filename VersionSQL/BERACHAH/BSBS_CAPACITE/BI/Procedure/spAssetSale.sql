/****** Object:  Procedure [BI].[spAssetSale]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spAssetSale](@FINYEAR INT,@PERIOD INT,@ASSETID INT  )
AS
  
DECLARE @ASSETPURCHASEVALUE DECIMAL(18,2)
DECLARE @ASSETACCUMDEPRECIATION DECIMAL(18,2)
DECLARE @SALEVALUE DECIMAL(18,2)
DECLARE @ASSETNUMBER VARCHAR(15)
DECLARE @OPPLEDGERCODE VARCHAR(10)
DECLARE @LASTDENUMBER INT 
DECLARE @ASSETPOSTDATE DATETIME 
DECLARE @AMOUNT DECIMAL(18,2)
SELECT @ASSETPOSTDATE = PEDATE FROM PERIODSETUP WHERE ORGID=2 AND PERIOD=@PERIOD   AND YEAR=@FINYEAR 
SELECT @ASSETPURCHASEVALUE=ASSETPPRICE, @ASSETACCUMDEPRECIATION = ASSETACCUMDEP FROM  ASSETS  WHERE ASSETID=@ASSETID 
SELECT @SALEVALUE = @ASSETPURCHASEVALUE-@ASSETACCUMDEPRECIATION

UPDATE ASSETS 
       SET 
	       ASSETSALE = @SALEVALUE,
	       ASSETCAP=-1.0*@ASSETACCUMDEPRECIATION,
		   ASSETSTATUS=3 ,
		   AssetSellDate = @ASSETPOSTDATE ,
		   AssetSellAmount = @SALEVALUE,
		   ASSETISDATE = @ASSETPOSTDATE
		   WHERE ASSETID=@ASSETID 
 

SET @AMOUNT = -1.0*@ASSETACCUMDEPRECIATION
SELECT @ASSETNUMBER=ASSETNUMBER,@OPPLEDGERCODE= ASSETOPPCODE ,@LASTDENUMBER = ASSETDEPPROG   FROM ASSETS WHERE ASSETID=@ASSETID 
 

INSERT INTO [BI].[ASSETPOSTS] (YEAR,PERIOD,ASSETID,ASSETNUMBER,LEDGERCODE,DEBIT,CURRNETCOUNT,BOOKINGDATE,DEPTYPE)
   VALUES (@FINYEAR,@PERIOD,@ASSETID,@ASSETNUMBER,@OPPLEDGERCODE,@AMOUNT,@LASTDENUMBER,@ASSETPOSTDATE,'SALE' )


Select 'Succes !!!!! ' AS RESULT




 