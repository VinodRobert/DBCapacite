/****** Object:  Table [dbo].[CREDEFT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CREDEFT](
	[BorgID] [int] NOT NULL,
	[CredID] [int] NOT NULL,
	[CredHold] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CREDEFT] ADD  CONSTRAINT [DF_CREDEFT_BorgID]  DEFAULT (1) FOR [BorgID]
ALTER TABLE [dbo].[CREDEFT] ADD  CONSTRAINT [DF_CREDEFT_CredID]  DEFAULT ((-1)) FOR [CredID]
ALTER TABLE [dbo].[CREDEFT] ADD  CONSTRAINT [DF_CREDEFT_CredHold]  DEFAULT (0) FOR [CredHold]