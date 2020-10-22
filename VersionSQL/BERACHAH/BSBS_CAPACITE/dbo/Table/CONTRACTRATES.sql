/****** Object:  Table [dbo].[CONTRACTRATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTRACTRATES](
	[stockid] [int] NOT NULL,
	[contractid] [int] NOT NULL,
	[rate] [money] NOT NULL,
	[borgid] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CONTRACTRATES] ADD  CONSTRAINT [DF_contractrates_rate]  DEFAULT (0) FOR [rate]