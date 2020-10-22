/****** Object:  Table [dbo].[OPBAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OPBAL](
	[LEDGERCODE] [nchar](10) NULL,
	[CREDNO] [varchar](10) NULL,
	[DESCRIPTION] [varchar](100) NULL,
	[DEBIT] [money] NULL,
	[CREDIT] [money] NULL
) ON [PRIMARY]