/****** Object:  Table [dbo].[ASSETS22MARCH2017_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ASSETS22MARCH2017_2](
	[AssetID] [int] IDENTITY(1,1) NOT NULL,
	[BorgID] [int] NOT NULL,
	[AssetNumber] [char](15) NULL,
	[AssetName] [char](55) NULL,
	[AssetPDate] [datetime] NULL,
	[AssetPPrice] [money] NOT NULL,
	[AssetInitAllow] [money] NOT NULL,
	[AssetDepMethod] [char](25) NULL,
	[AssetPeriod] [numeric](18, 2) NOT NULL,
	[AssetBookValue] [money] NOT NULL,
	[AssetAccumDep] [money] NOT NULL,
	[AssetMarketValue] [money] NOT NULL,
	[AssetLastPostDate] [datetime] NULL,
	[AssetPost] [bit] NOT NULL,
	[AssetLifeHours] [numeric](18, 0) NOT NULL,
	[AssetHrsToDate] [numeric](18, 0) NOT NULL,
	[AssetDepCode] [char](10) NULL,
	[AssetAlloc] [char](25) NULL,
	[AssetOppCode] [char](10) NULL,
	[AssetOppAlloc] [char](25) NULL,
	[AssetDepProg] [numeric](18, 0) NOT NULL,
	[AssetSalvage] [money] NOT NULL,
	[AssetDepTM] [money] NOT NULL,
	[AssetAdd] [money] NOT NULL,
	[AssetSale] [money] NOT NULL,
	[AssetRevalu] [money] NOT NULL,
	[ToJoinAsset] [int] NOT NULL,
	[AssetLocation] [char](50) NOT NULL,
	[AssetContact] [char](30) NOT NULL,
	[AssetCategory] [nvarchar](110) NOT NULL,
	[AssetAllocDiv] [int] NOT NULL,
	[Usage] [numeric](18, 0) NOT NULL,
	[AssetStatus] [int] NOT NULL,
	[AssetSellDate] [datetime] NULL,
	[AssetSellAmount] [money] NOT NULL,
	[Assetagreeno] [char](25) NOT NULL,
	[Assetinvoice] [char](10) NOT NULL,
	[AssetiDate] [datetime] NULL,
	[AssetoiRate] [numeric](18, 3) NOT NULL,
	[AssetfPeriod] [numeric](18, 0) NOT NULL,
	[AssetisDate] [datetime] NULL,
	[AssetifDate] [datetime] NULL,
	[AssetFees] [money] NOT NULL,
	[AssetFeesOffBS] [money] NOT NULL,
	[AssetIntRebate] [money] NOT NULL,
	[AssetReg] [money] NOT NULL,
	[AssetCap] [money] NOT NULL,
	[AssetDep] [money] NOT NULL,
	[AssetFin] [money] NOT NULL,
	[AssetVAT] [money] NOT NULL,
	[AssetRepDate] [datetime] NULL,
	[AssetFinCharge] [money] NOT NULL,
	[AssetFinPost] [bit] NOT NULL,
	[AssetMonthPay] [money] NOT NULL,
	[AssetFinPay] [money] NOT NULL,
	[AssetCred] [char](10) NOT NULL,
	[AssetFinCom] [char](10) NOT NULL,
	[AssetBank] [char](10) NOT NULL,
	[AssetCostAlloc] [char](10) NOT NULL,
	[AssetIsVATFin] [bit] NOT NULL,
	[AssetPDebt] [money] NOT NULL,
	[AssetTColl] [money] NOT NULL,
	[AssetDefAcc] [char](10) NOT NULL,
	[AssetLDate] [datetime] NULL,
	[AssetIRDate] [datetime] NULL,
	[AssetVATType] [char](2) NOT NULL,
	[AssetDepAcc] [char](10) NOT NULL,
	[AssetRepAcc] [char](10) NOT NULL,
	[ASSETTAXDEPPERCS] [nvarchar](50) NOT NULL,
	[ASSETTAXDEPTYPE] [int] NOT NULL,
	[ASSETTAXYEARS] [char](6) NOT NULL,
	[ASSETTAXPPRICE] [money] NOT NULL,
	[ASSETISIFRS] [bit] NOT NULL,
	[LASTDEPTM] [decimal](18, 4) NOT NULL,
	[ASSETSPLIT] [decimal](18, 4) NOT NULL,
	[INSURANCEVALUE] [money] NOT NULL,
	[ASSETHRSTODATEPREV] [numeric](18, 0) NOT NULL
) ON [PRIMARY]