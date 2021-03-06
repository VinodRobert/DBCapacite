/****** Object:  Table [dbo].[DEBTORSAC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTORSAC](
	[BorgID] [int] NOT NULL,
	[AssCode] [char](10) NOT NULL,
	[AssLedger] [char](80) NOT NULL,
	[AssDescr] [nchar](80) NOT NULL,
	[AssUse] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTORSAC] ADD  CONSTRAINT [DF_DEBTORSAC_BorgID]  DEFAULT ((1)) FOR [BorgID]
ALTER TABLE [dbo].[DEBTORSAC] ADD  CONSTRAINT [DF_DEBTORSAC_AssCode]  DEFAULT ('') FOR [AssCode]
ALTER TABLE [dbo].[DEBTORSAC] ADD  CONSTRAINT [DF_DEBTORSAC_AssLedger]  DEFAULT ('') FOR [AssLedger]
ALTER TABLE [dbo].[DEBTORSAC] ADD  CONSTRAINT [DF_DEBTORSAC_AssDescr]  DEFAULT ('') FOR [AssDescr]
ALTER TABLE [dbo].[DEBTORSAC] ADD  CONSTRAINT [DF_DEBTORSAC_AssUse]  DEFAULT ((0)) FOR [AssUse]