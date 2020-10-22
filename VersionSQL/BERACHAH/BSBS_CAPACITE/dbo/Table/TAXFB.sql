/****** Object:  Table [dbo].[TAXFB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TAXFB](
	[FBID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SECTION] [nvarchar](10) NOT NULL,
	[LEDGERCODE] [nvarchar](10) NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
	[CONSIDER] [numeric](18, 4) NOT NULL,
	[RATE] [numeric](18, 4) NOT NULL,
	[LedgerCodeCostTo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TAXFB] PRIMARY KEY CLUSTERED 
(
	[FBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_SECTION]  DEFAULT ('') FOR [SECTION]
ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_LEDGERCODE]  DEFAULT ('') FOR [LEDGERCODE]
ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_CONSIDER]  DEFAULT ((0)) FOR [CONSIDER]
ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_RATE]  DEFAULT ((0)) FOR [RATE]
ALTER TABLE [dbo].[TAXFB] ADD  CONSTRAINT [DF_TAXFB_LedgerCodeCastTo]  DEFAULT ('') FOR [LedgerCodeCostTo]