/****** Object:  Table [BT].[WORKORDEROB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[WORKORDEROB](
	[PROJECTCODE] [int] NULL,
	[TOOLCODE] [varchar](15) NULL,
	[OPENINGQTY] [decimal](18, 2) NULL,
	[OPENINGRATE] [decimal](18, 2) NULL,
	[OPENINGVALUE] [decimal](18, 2) NULL
) ON [PRIMARY]