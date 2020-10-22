/****** Object:  Table [dbo].[JAI]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JAI](
	[BORGID] [int] NOT NULL,
	[ORGID] [int] NULL,
	[STKSTORE] [char](15) NOT NULL,
	[STORE] [varchar](25) NULL,
	[STKCODE] [char](20) NOT NULL,
	[STOCKCODE] [varchar](20) NULL,
	[StkQuantity] [numeric](18, 4) NOT NULL,
	[QTY] [decimal](38, 4) NULL
) ON [PRIMARY]