/****** Object:  Table [dbo].[DEBTORRATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTORRATES](
	[stockid] [int] NOT NULL,
	[debtcode] [char](10) NOT NULL,
	[debtrate] [money] NOT NULL,
	[borgid] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTORRATES] ADD  CONSTRAINT [DF_DEBTRATES_debtcode]  DEFAULT ('') FOR [debtcode]
ALTER TABLE [dbo].[DEBTORRATES] ADD  CONSTRAINT [DF_DEBTRATES_debtrate]  DEFAULT (0) FOR [debtrate]