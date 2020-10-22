/****** Object:  Table [BT].[CTCREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[CTCREPORT](
	[NODEID] [bigint] NULL,
	[SECTION] [varchar](10) NULL,
	[LEVELCODE] [varchar](10) NULL,
	[HEADERCODE] [varchar](5) NULL,
	[SPACECODE] [int] NULL,
	[DESCRIPTION] [varchar](200) NULL,
	[PARENTID] [varchar](10) NULL,
	[FORMULA] [varchar](255) NULL
) ON [PRIMARY]