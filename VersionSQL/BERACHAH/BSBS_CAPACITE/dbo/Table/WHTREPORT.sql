/****** Object:  Table [dbo].[WHTREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WHTREPORT](
	[WHTTYPE] [int] NULL,
	[CREDNO] [char](10) NULL,
	[CREDNAME] [varchar](55) NULL,
	[TRANSTYPE] [varchar](10) NULL,
	[YEAR] [char](10) NULL,
	[PERIOD] [int] NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [char](10) NULL,
	[TRANSREF] [char](10) NULL,
	[DESCRIPTION] [varchar](255) NULL,
	[BILLAMOUNT] [numeric](18, 2) NULL,
	[WHTAMOUNT] [numeric](18, 2) NULL,
	[SECTION] [varchar](10) NULL,
	[RATE] [numeric](18, 4) NULL,
	[REMARKS] [varchar](100) NULL,
	[TRANSID] [int] NULL,
	[WHTID] [int] NULL,
	[POSITION] [int] NULL,
	[CODE] [nchar](10) NULL,
	[CODEDESCRIPTION] [varchar](100) NULL
) ON [PRIMARY]