/****** Object:  Table [BT].[DPRNOTES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[DPRNOTES](
	[PROJECTCODE] [int] NULL,
	[DPRDATE] [datetime] NULL,
	[HINDERANCES] [varchar](600) NULL,
	[NOTES] [varchar](600) NULL
) ON [PRIMARY]