/****** Object:  Table [dbo].[invtranslist23feb17]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[invtranslist23feb17](
	[IRID] [int] IDENTITY(1,1) NOT NULL,
	[IRUserID] [int] NOT NULL,
	[IRBorgID] [int] NOT NULL,
	[IRTransTableID] [int] NOT NULL,
	[IRGlCode] [char](10) NOT NULL,
	[IRTyeName] [char](25) NOT NULL,
	[IRSStktore] [char](15) NOT NULL,
	[IRStkCode] [char](20) NOT NULL,
	[IRTrasRef] [char](10) NOT NULL,
	[IRreqNo] [char](55) NOT NULL,
	[IRQuantity] [numeric](18, 4) NULL,
	[IRToBorg] [int] NOT NULL,
	[IRTrasDate] [datetime] NOT NULL,
	[IRReadingID] [int] NULL,
	[IRRemove] [bit] NOT NULL
) ON [PRIMARY]