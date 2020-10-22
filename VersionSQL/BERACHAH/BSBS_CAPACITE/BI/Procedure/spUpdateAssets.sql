/****** Object:  Procedure [BI].[spUpdateAssets]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spUpdateAssets](@AssetID  INT, @AssetCategory VARCHAR(150),@AssetNumber VARCHAR(15), @AssetName VARCHAR(55),
@AssetPurchaseValue DECIMAL(18,2), @AssetSalvageValue DECIMAL(18,2), @AssetLife INT, @LifeDepreciated INT, @AccumulatedDepreciation DECIMAL(18,2),
@AssetPutToUse DateTime, @AssetLocation VARCHAR(50), @GRN VARCHAR(50), @AssetOrderID int,@AssetInvoiceNo VARCHAR(50),@DutyBenefit Decimal(18,2), @FERevaluation Decimal(18,2) )
AS
BEGIN

    DECLARE  @BorgID INT
	SET @BORGID=2

	DECLARE  @AssetPDate  DATETIME
	SET @ASSETPDATE = @AssetPutToUse

    DECLARE @AssetPPrice DECIMAL(18,2)
    SET @AssetPPrice = @AssetPurchaseValue

    DECLARE @AssetDepMethod VARCHAR(20)
	SET @AssetDepMethod = 'Straight Line            '

    DECLARE @AssetPeriod INT
	SET @AssetPeriod = @AssetLife

    DECLARE @AssetBookValue DECIMAL(18,2)
	SET @AssetBookValue = @AssetPurchaseValue - @AccumulatedDepreciation
    
	

    DECLARE @AssetDepCode VARCHAR(10)
	SET @AssetDepCode ='6060005'
	   
    DECLARE @AssetAlloc VARCHAR(10)
	SET @AssetAlloc = 'Overheads'

    DECLARE @AssetOppCode VARCHAR(10)
   
    SET @ASSETNUMBER = LTRIM(RTRIM(@ASSETNUMBER)) 
    
  --   THIS IS THE MASTER LIST 
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'PLANT AND MACHINERY   ' , LEDGERCODE = '2200001'  WHERE ASSETCATEGORY = 'PLANT AND MACHINERY'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'FURNITURE AND FIXTURES' , LEDGERCODE = '2200002'  WHERE ASSETCATEGORY = 'FURNITURE AND FIXTURES'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'COMPUTERS AND PRINTERS' , LEDGERCODE = '2200003'  WHERE ASSETCATEGORY = 'COMPUTERS AND PRINTERS'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'FORMWORK              ' , LEDGERCODE = '2200004'  WHERE ASSETCATEGORY = 'FORMWORK'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'VEHICLES              ' , LEDGERCODE = '2200005'  WHERE ASSETCATEGORY = 'VEHICLES'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'OFFICE EQUIPMENTS     ' , LEDGERCODE = '2200006'  WHERE ASSETCATEGORY = 'OFFICE EQUIPMENTS'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'BUILDINGS             ' , LEDGERCODE = '2200007'  WHERE ASSETCATEGORY = 'BUILDINGS'
  --   UPDATE #TEMPASSETREPORTSUMMARY SET LEDGERNAME = 'COMPUTER SOFTWARE     ' , LEDGERCODE = '2201000'  WHERE ASSETCATEGORY = 'COMPUTER SOFTWARE'







	IF @ASSETCATEGORY = 'Vehicles'
	 BEGIN
	   SET @ASSETCATEGORY ='VEHICLES'
	   SET @ASSETOPPCODE = '2200005'
	 END 

	IF @ASSETCATEGORY = 'Form Work Equipment'
	 BEGIN
	   SET @ASSETCATEGORY ='FORMWORK'
	   SET @ASSETOPPCODE = '2200004'
	 END

    IF @ASSETCATEGORY = 'Plant  and Machinery'
	 BEGIN
	   SET @ASSETCATEGORY = 'PLANT AND MACHINERY'
	   SET @ASSETOPPCODE = '2200001'
	 END

	IF @ASSETCATEGORY = 'Furniture and Fixtures'
	 BEGIN
	   SET @ASSETCATEGORY = 'FURNITURE AND FIXTURES'
	   SET @ASSETOPPCODE = '2200002'
	 END

    IF @ASSETCATEGORY = 'Computers  and Printers'
	 BEGIN
	   SET @ASSETCATEGORY = 'COMPUTERS AND PRINTERS'
	   SET @ASSETOPPCODE = '2200003'
	 END

	IF @ASSETCATEGORY = 'Office Equipments'
	 BEGIN
	   SET @ASSETCATEGORY = 'OFFICE EQUIPMENTS'
	   SET @ASSETOPPCODE = '2200006'
	 END

    IF @ASSETCATEGORY = 'Office Premises'
	 BEGIN
	   SET @ASSETCATEGORY = 'BUILDINGS'
	   SET @ASSETOPPCODE = '2200007'
	 END

	IF @ASSETCATEGORY = 'Softwares'
	 BEGIN
	   SET @ASSETCATEGORY = 'COMPUTER SOFTWARE'
	   SET @ASSETOPPCODE = '2201000'
	 END

	 

    DECLARE  @AssetOppAlloc VARCHAR(45)
	SET @AssetOppAlloc ='Balance Sheet'

	DECLARE @AssetDepProg INT
	SET @AssetDepProg = @LifeDepreciated

	DECLARE @AssetSalvage DECIMAL(18,2)
	SET  @AssetSalvage = @AssetSalvageValue

	DECLARE @AssetDepTM  INT
	SET @AssetDepTM =@AssetLife 

	DECLARE @maxAssetID INT

    IF @ASSETID = 0
	   BEGIN
	     
	     INSERT INTO [dbo].[ASSETS]
           ([BorgID]
           ,[AssetNumber]
           ,[AssetName]
           ,[AssetPDate]
           ,[AssetPPrice]
           ,[AssetDepMethod]
           ,[AssetPeriod]
           ,[AssetBookValue]
           ,[AssetAccumDep]
           ,[AssetDepCode]
           ,[AssetAlloc]
           ,[AssetOppCode]
           ,[AssetOppAlloc]
           ,[AssetDepProg]
           ,[AssetSalvage]
           ,[AssetDepTM]
           ,[AssetLocation]
           ,[AssetCategory]
		   ,[ASSETISIFRS]
		   ,[ASSETFPERIOD]
		   ,[ASSETLIFEHOURS]
		   ,[ASSETALLOCDIV]
          )
        VALUES
           (@BorgID 
           ,@AssetNumber 
           ,@AssetName 
           ,@AssetPDate 
           ,@AssetPPrice 
           ,@AssetDepMethod 
           ,@AssetPeriod 
           ,@AssetBookValue 
           ,@AccumulatedDepreciation
           ,@AssetDepCode 
           ,@AssetAlloc 
           ,@AssetOppCode 
           ,@AssetOppAlloc 
           ,@AssetDepProg 
           ,@AssetSalvage 
           ,@AssetDepTM 
           ,@AssetLocation  
           ,@AssetCategory 
		   ,1
		   ,36
		   ,@AssetPeriod 
		   ,44
          )
    	   SELECT @maxAssetID = max(AssetID) from Assets 
		   INSERT INTO attribvalue(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX) VALUES
			(@maxAssetID,'ASSETS','GRN',@GRN, -1, GETDATE(), 0)
		   INSERT INTO attribvalue(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX) VALUES
			(@maxAssetID,'ASSETS','ORDID',@AssetOrderID, -1, GETDATE(), 0)
		   INSERT INTO attribvalue(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX) VALUES
			(@maxAssetID,'ASSETS','INVOICENO',@AssetInvoiceNo, -1, GETDATE(), 0)
           INSERT INTO attribvalue(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX) VALUES
			(@maxAssetID,'ASSETS','DUTYBENEFITS',@DutyBenefit, -1, GETDATE(), 0)
		   INSERT INTO attribvalue(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX) VALUES
			(@maxAssetID,'ASSETS','FEREVALUATION',@FERevaluation, -1, GETDATE(), 0)

		   UPDATE ASSETS
		      SET AssetPost=0,ASSETDEPPROG=0,ASSETBOOKVALUE=ASSETPPRICE,
			      LASTDEPTM=(ASSETPPRICE-ASSETSALVAGE)/ASSETDEPTM ,AssetAccumDep=0  ,ASSETALLOCDIV=44
			  WHERE ASSETID = @MAXASSETID 
		END
	ELSE
	   BEGIN
	       UPDATE ASSETS 
		    SET ASSETNAME = @ASSETNAME,
			    ASSETPDATE = @ASSETPDATE,
				[AssetPPrice]=@AssetPPrice,
				[AssetPeriod]=@AssetPeriod,
				[AssetBookValue]=@AssetBookValue,
				[AssetAccumDep]=@AccumulatedDepreciation,
				[AssetSalvage]=@AssetSalvage,
				[AssetLocation]=@AssetLocation,
				[AssetCategory]=@AssetCategory,
				[Assetdepprog]=@LifeDepreciated 
			WHERE 
			    [AssetNumber]=@ASSETNUMBER 
			
			UPDATE ASSETS
		      SET AssetPost=0,ASSETBOOKVALUE=ASSETPPRICE,
			      LASTDEPTM=(ASSETPPRICE-ASSETSALVAGE)/ASSETDEPTM  
			  WHERE [AssetNumber]=@ASSETNUMBER 
	              
			UPDATE ATTRIBVALUE SET VALUE = @GRN WHERE COLKEY=@ASSETID AND TABLENAME='ASSETS' AND ATTRIBUTE='GRN'
			UPDATE ATTRIBVALUE SET VALUE = @ASSETORDERID WHERE COLKEY=@ASSETID AND TABLENAME='ASSETS' AND ATTRIBUTE='ORDID'
			UPDATE ATTRIBVALUE SET VALUE = @AssetInvoiceNo WHERE COLKEY=@ASSETID AND TABLENAME='ASSETS' AND ATTRIBUTE = 'INVOICENO'
			UPDATE ATTRIBVALUE SET VALUE = @DutyBenefit WHERE COLKEY=@ASSETID AND TABLENAME='ASSETS' AND ATTRIBUTE='DUTYBENEFITS'
			UPDATE ATTRIBVALUE SET VALUE = @FERevaluation WHERE COLKEY=@ASSETID AND TABLENAME='ASSETS' AND ATTRIBUTE = 'FEREVALUATION'  
		END 

END