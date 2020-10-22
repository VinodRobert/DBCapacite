/****** Object:  Procedure [dbo].[vrLoadPlantAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  procedure dbo.vrLoadPlantAttributes
as
  DECLARE @PROJECTCODE VARCHAR(10)
  DECLARE @ASSSETTYPE  VARCHAR(2)
  DECLARE @ASSETCODE   VARCHAR(15)
  DECLARE @ASSETNAME   VARCHAR(35)
  DECLARE @UOM         VARCHAR(10)
  DECLARE @RATE        DECIMAL(18,2)
  DECLARE @QTY         DECIMAL(18,2)
  DECLARE @VALUE       DECIMAL(18,2) 
  DECLARE @BORGID      INT
  DECLARE @ASSETCATS   VARCHAR(10) 
  DECLARE @NEWASSETCODE INT 


  DECLARE ASSETS CURSOR FOR SELECT * FROM VR_ASSETMASTER 
  OPEN ASSETS
  FETCH NEXT FROM ASSETS INTO @PROJECTCODE,@ASSSETTYPE,@ASSETCODE,@ASSETNAME,@UOM,@RATE,@QTY,@VALUE,@BORGID 
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @PROJECTCODE,@ASSETCODE 
 --   IF @ASSSETTYPE = 'SE' 
	--   SET @ASSETCATS = 'SE|SO' 
	--ELSE
	--   SET @ASSETCATS = 'SE|LC' 

    --INSERT INTO [dbo].[ASSETS]
    --       ([BorgID]
    --       ,[AssetNumber]
    --       ,[AssetName]
    --       ,[AssetPDate]
    --       ,[AssetPPrice]
    --       ,[AssetInitAllow]
    --       ,[AssetDepMethod]
    --       ,[AssetPeriod]
    --       ,[AssetBookValue]
    --       ,[AssetAccumDep]
    --       ,[AssetMarketValue]
    --       ,[AssetLastPostDate]
    --       ,[AssetPost]
    --       ,[AssetLifeHours]
    --       ,[AssetHrsToDate]
    --       ,[AssetDepCode]
    --       ,[AssetAlloc]
    --       ,[AssetOppCode]
    --       ,[AssetOppAlloc]
    --       ,[AssetDepProg]
    --       ,[AssetSalvage]
    --       ,[AssetDepTM]
    --       ,[AssetAdd]
    --       ,[AssetSale]
    --       ,[AssetRevalu]
    --       ,[ToJoinAsset]
    --       ,[AssetLocation]
    --       ,[AssetContact]
    --       ,[AssetCategory]
    --       ,[AssetAllocDiv]
    --       ,[Usage]
    --       ,[AssetStatus]
    --       ,[AssetSellDate]
    --       ,[AssetSellAmount]
    --       ,[Assetagreeno]
    --       ,[Assetinvoice]
    --       ,[AssetiDate]
    --       ,[AssetoiRate]
    --       ,[AssetfPeriod]
    --       ,[AssetisDate]
    --       ,[AssetifDate]
    --       ,[AssetFees]
    --       ,[AssetFeesOffBS]
    --       ,[AssetIntRebate]
    --       ,[AssetReg]
    --       ,[AssetCap]
    --       ,[AssetDep]
    --       ,[AssetFin]
    --       ,[AssetVAT]
    --       ,[AssetRepDate]
    --       ,[AssetFinCharge]
    --       ,[AssetFinPost]
    --       ,[AssetMonthPay]
    --       ,[AssetFinPay]
    --       ,[AssetCred]
    --       ,[AssetFinCom]
    --       ,[AssetBank]
    --       ,[AssetCostAlloc]
    --       ,[AssetIsVATFin]
    --       ,[AssetPDebt]
    --       ,[AssetTColl]
    --       ,[AssetDefAcc]
    --       ,[AssetLDate]
    --       ,[AssetIRDate]
    --       ,[AssetVATType]
    --       ,[AssetDepAcc]
    --       ,[AssetRepAcc]
    --       ,[ASSETTAXDEPPERCS]
    --       ,[ASSETTAXDEPTYPE]
    --       ,[ASSETTAXYEARS]
    --       ,[ASSETTAXPPRICE]
    --       ,[ASSETISIFRS]
    --       ,[LASTDEPTM]
    --       ,[ASSETSPLIT]
    --       ,[INSURANCEVALUE])
    -- VALUES
    --       (@BORGID 
    --       ,@ASSETCODE
    --       ,@ASSETNAME
    --       ,'01-APR-2014'
    --       ,@VALUE
    --       ,0
    --       ,'Straight Line'
    --       ,24
    --       ,@VALUE
    --       ,0
    --       ,0
    --       ,GETDATE()
    --       ,0
    --       ,0
    --       ,0
    --       ,'6060008' 
    --       ,'Overheads'                
    --       ,'2200099'
    --       ,'Balance Sheet' 
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,12
    --       ,@PROJECTCODE 
    --       ,SPACE(30)
    --       ,@ASSETCATS
    --       ,26
    --       ,0
    --       ,0
    --       ,NULL
    --       ,0
    --       ,SPACE(25)
    --       ,SPACE(10)
    --       ,NULL
    --       ,0
    --       ,24
    --       ,NULL
    --       ,NULL
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,0
    --       ,SPACE(10)
    --       ,SPACE(10)
    --       ,SPACE(10)
    --       ,SPACE(10)
    --       ,0
    --       ,0
    --       ,0
    --       ,SPACE(10)
		  -- ,SPACE(10)
    --       ,GETDATE()
    --       ,GETDATE()
    --       ,'Z'
    --       ,SPACE(10)
    --       ,SPACE(10)
    --       ,0
    --       ,0
    --       ,0
		  -- ,0
		  -- ,0
    --       ,0
    --       ,0
    --       ,0)
 
    --SELECT @NEWASSETCODE=MAX(ASSETID) FROM ASSETS 
	,@ASSSETTYPE,@ASSETCODE,@ASSETNAME,@UOM,@RATE,@QTY,@VALUE,@BORGID
    INSERT INTO [dbo].[ATTRIBVALUE]
           ([COLKEY]
           ,[TABLENAME]
           ,[ATTRIBUTE]
           ,[VALUE]
           ,[USERID]
           ,[LOGDATETIME]
           ,[ARRAYINDEX])
     VALUES
           (@PROJECTCODE
           ,'ASSETS' 
           ,'LOC'
           ,@BORGID 
           ,'227'
           ,GETDATE()
           ,0)

    INSERT INTO [dbo].[ATTRIBVALUE]
           ([COLKEY]
           ,[TABLENAME]
           ,[ATTRIBUTE]
           ,[VALUE]
           ,[USERID]
           ,[LOGDATETIME]
           ,[ARRAYINDEX])
     VALUES
           (@PROJECTCODE
           ,'ASSETS' 
           ,'QTY'
           ,@QTY
           ,'227'
           ,GETDATE()
           ,0)


	--INSERT INTO [dbo].[ATTRIBVALUE]
 --          ([COLKEY]
 --          ,[TABLENAME]
 --          ,[ATTRIBUTE]
 --          ,[VALUE]
 --          ,[USERID]
 --          ,[LOGDATETIME]
 --          ,[ARRAYINDEX])
 --    VALUES
 --          (@PROJECTCODE
 --          ,'ASSETS' 
 --          ,'RATE'
 --          ,@RATE
 --          ,'227'
 --          ,GETDATE()
 --          ,0)

	INSERT INTO [dbo].[ATTRIBVALUE]
           ([COLKEY]
           ,[TABLENAME]
           ,[ATTRIBUTE]
           ,[VALUE]
           ,[USERID]
           ,[LOGDATETIME]
           ,[ARRAYINDEX])
     VALUES
           (@PROJECTCODE
           ,'ASSETS' 
           ,'UNIT'
           ,@UOM
           ,'227'
           ,GETDATE()
           ,0)

   FETCH NEXT FROM ASSETS INTO @PROJECTCODE,@ASSSETTYPE,@ASSETCODE,@ASSETNAME,@UOM,@RATE,@QTY,@VALUE,@BORGID 
  END

  CLOSE ASSETS
  DEALLOCATE ASSETS 

	

 