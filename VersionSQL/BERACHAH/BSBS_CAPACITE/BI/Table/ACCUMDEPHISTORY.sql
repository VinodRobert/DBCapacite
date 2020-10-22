/****** Object:  Table [BI].[ACCUMDEPHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[ACCUMDEPHISTORY](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ASSETID] [int] NULL,
	[FINYEAR] [int] NULL,
	[ASSETNUMBER] [varchar](15) NULL,
	[ASSETNAME] [varchar](55) NULL,
	[DEPCOUNT] [int] NULL,
	[DEPAMOUNT] [decimal](18, 2) NULL,
	[LEDGERCODE] [varchar](10) NULL
) ON [PRIMARY]