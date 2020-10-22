/****** Object:  Table [BS].[PANDL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[PANDL](
	[ledgeralloc] [varchar](100) NULL,
	[ledgercode] [varchar](15) NULL,
	[ledgername] [varchar](100) NULL,
	[debit] [money] NULL,
	[credit] [money] NULL,
	[projectname] [varchar](100) NULL,
	[parent] [varchar](100) NULL
) ON [PRIMARY]