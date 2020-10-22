/****** Object:  Table [BS].[CASHFLOW]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[CASHFLOW](
	[ROWINDEX] [int] NULL,
	[CATEGORY] [int] NULL,
	[COL1INDEX] [int] NULL,
	[COL1CODE] [varchar](10) NULL,
	[COL1NAME] [varchar](50) NULL,
	[COL1FONT] [int] NULL,
	[COL1VALUE] [decimal](18, 2) NULL,
	[COL2INDEX] [int] NULL,
	[COL2CODE] [varchar](10) NULL,
	[COL2NAME] [varchar](50) NULL,
	[COL2FONT] [int] NULL,
	[COL2VALUE] [decimal](18, 2) NULL
) ON [PRIMARY]