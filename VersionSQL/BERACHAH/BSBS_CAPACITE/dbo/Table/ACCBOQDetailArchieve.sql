/****** Object:  Table [dbo].[ACCBOQDetailArchieve]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ACCBOQDetailArchieve](
	[MonthEndID] [int] NULL,
	[DetailId] [int] NOT NULL,
	[HeaderId] [int] NOT NULL,
	[quantity] [numeric](18, 4) NOT NULL,
	[prog QTY] [numeric](18, 4) NOT NULL,
	[prev QTY] [numeric](18, 4) NOT NULL,
	[final QTY] [numeric](18, 4) NOT NULL,
	[rate] [numeric](18, 4) NOT NULL,
	[amount] [numeric](18, 4) NOT NULL,
	[ACTID] [char](10) NOT NULL
) ON [PRIMARY]