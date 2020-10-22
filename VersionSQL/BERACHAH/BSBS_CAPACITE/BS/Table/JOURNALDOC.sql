/****** Object:  Table [BS].[JOURNALDOC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[JOURNALDOC](
	[HEADID] [int] NULL,
	[ORGID] [int] NULL,
	[BATCHREF] [varchar](10) NULL,
	[TRANSREF] [varchar](10) NULL,
	[HEADTRANSREF] [varchar](10) NULL,
	[DOCID] [int] NOT NULL
) ON [PRIMARY]