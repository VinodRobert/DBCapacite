/****** Object:  Table [BI].[ASSETREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[ASSETREPORT](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ASSETCATEGORY] [varchar](100) NULL,
	[ASSETID] [int] NULL,
	[ASSETNUMBER] [varchar](15) NULL,
	[ASSETNAME] [varchar](55) NULL,
	[PUTINUSE] [datetime] NULL,
	[PURCHASE_VALUE] [decimal](18, 2) NULL,
	[ADDITIONS_VALUE] [decimal](18, 2) NULL,
	[DELETE_VALUE] [decimal](18, 2) NULL,
	[SALVAGE_VALUE] [decimal](18, 2) NULL,
	[ASSETMAXLIFE] [int] NULL,
	[OPENINGLIFE] [int] NULL,
	[MONTHLYDEP] [decimal](18, 2) NULL,
	[ACCUMULATED_DEP] [decimal](18, 2) NULL,
	[APRIL] [decimal](18, 2) NULL,
	[MAY] [decimal](18, 2) NULL,
	[JUNE] [decimal](18, 2) NULL,
	[JULY] [decimal](18, 2) NULL,
	[AUGUST] [decimal](18, 2) NULL,
	[SEPTEMBER] [decimal](18, 2) NULL,
	[OCTOBER] [decimal](18, 2) NULL,
	[NOVEMBER] [decimal](18, 2) NULL,
	[DECEMBER] [decimal](18, 2) NULL,
	[JANUARY] [decimal](18, 2) NULL,
	[FEBRUARY] [decimal](18, 2) NULL,
	[MARCH] [decimal](18, 2) NULL,
	[ADDITIONS_DEP] [decimal](18, 2) NULL,
	[DELETIONS_DEP] [decimal](18, 2) NULL,
	[BOOKVALUE] [decimal](18, 2) NULL,
	[CLOSINGLIFE] [int] NULL,
	[LOCATION] [varchar](50) NULL,
	[SALEDATE] [datetime] NULL,
	[SALEVALUE] [decimal](18, 2) NULL,
	[LIVESTATUS] [nchar](10) NULL
) ON [PRIMARY]