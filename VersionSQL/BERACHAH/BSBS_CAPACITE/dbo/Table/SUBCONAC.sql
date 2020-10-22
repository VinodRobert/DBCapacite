/****** Object:  Table [dbo].[SUBCONAC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCONAC](
	[BorgID] [int] NOT NULL,
	[AssCode] [char](10) NOT NULL,
	[AssLedger] [char](80) NOT NULL,
	[AssDescr] [nchar](80) NOT NULL,
	[AssUse] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCONAC] ADD  CONSTRAINT [DF_SUBCONAC_BorgID]  DEFAULT ((1)) FOR [BorgID]
ALTER TABLE [dbo].[SUBCONAC] ADD  CONSTRAINT [DF_SUBCONAC_AssCode]  DEFAULT ('') FOR [AssCode]
ALTER TABLE [dbo].[SUBCONAC] ADD  CONSTRAINT [DF_SUBCONAC_AssLedger]  DEFAULT ('') FOR [AssLedger]
ALTER TABLE [dbo].[SUBCONAC] ADD  CONSTRAINT [DF_SUBCONAC_AssDescr]  DEFAULT ('') FOR [AssDescr]
ALTER TABLE [dbo].[SUBCONAC] ADD  CONSTRAINT [DF_SUBCONAC_AssUse]  DEFAULT ((0)) FOR [AssUse]