/****** Object:  Table [BT].[MANPOWERBUDGET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MANPOWERBUDGET](
	[BUDGETID] [int] NOT NULL,
	[PROJECTCODE] [int] NULL,
	[SKILLTYPECODE] [varchar](15) NULL,
	[SKILLTYPE] [varchar](255) NULL,
	[BUDGETCOUNT] [decimal](18, 2) NULL,
	[REVISIONID] [decimal](6, 2) NULL
) ON [PRIMARY]