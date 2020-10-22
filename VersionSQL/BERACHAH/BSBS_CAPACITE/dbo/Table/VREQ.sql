/****** Object:  Table [dbo].[VREQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VREQ](
	[HEADERID] [int] NULL,
	[TOOLCODE] [varchar](25) NULL,
	[LINENUMBER] [int] NULL,
	[STOCKID] [int] NULL,
	[QTY] [decimal](18, 4) NULL
) ON [PRIMARY]