/****** Object:  Table [BS].[STOCKUPLOAD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[STOCKUPLOAD](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BORGID] [int] NULL,
	[STORE] [varchar](10) NULL,
	[STOCKCODE] [varchar](10) NULL,
	[QTY] [decimal](18, 4) NULL,
	[RATE] [decimal](18, 2) NULL
) ON [PRIMARY]