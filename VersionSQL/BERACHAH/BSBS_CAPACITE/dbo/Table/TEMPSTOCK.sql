/****** Object:  Table [dbo].[TEMPSTOCK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TEMPSTOCK](
	[STORE] [varchar](50) NULL,
	[STOCKNO] [varchar](100) NULL,
	[PARTICULARS] [varchar](500) NULL,
	[UNITS] [varchar](50) NULL,
	[RATE] [numeric](18, 2) NULL,
	[STOCK] [numeric](18, 4) NULL
) ON [PRIMARY]