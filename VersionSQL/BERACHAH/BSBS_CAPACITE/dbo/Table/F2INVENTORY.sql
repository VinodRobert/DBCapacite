/****** Object:  Table [dbo].[F2INVENTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[F2INVENTORY](
	[STKSTORE] [char](15) NOT NULL,
	[STKCODE] [char](20) NOT NULL,
	[STKDESC] [char](250) NULL,
	[STKUNIT] [char](8) NULL,
	[STKQUANTITY] [numeric](38, 4) NULL,
	[STKCOSTRATE] [money] NULL
) ON [PRIMARY]