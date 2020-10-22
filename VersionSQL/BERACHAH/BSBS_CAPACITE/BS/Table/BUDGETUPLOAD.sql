/****** Object:  Table [BS].[BUDGETUPLOAD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[BUDGETUPLOAD](
	[FINYEAR] [int] NULL,
	[ORGID] [int] NULL,
	[LEDGERCODE] [varchar](10) NULL,
	[BUDGET] [decimal](18, 2) NULL
) ON [PRIMARY]