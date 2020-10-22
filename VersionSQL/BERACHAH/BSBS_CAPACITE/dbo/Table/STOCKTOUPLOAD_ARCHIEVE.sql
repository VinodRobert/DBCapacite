/****** Object:  Table [dbo].[STOCKTOUPLOAD_ARCHIEVE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STOCKTOUPLOAD_ARCHIEVE](
	[STKSTORE] [varchar](50) NULL,
	[STKCODE] [varchar](50) NULL,
	[STKQUANTITY] [decimal](18, 0) NULL,
	[STKCOSTRATE] [money] NULL,
	[BORGID] [int] NULL
) ON [PRIMARY]