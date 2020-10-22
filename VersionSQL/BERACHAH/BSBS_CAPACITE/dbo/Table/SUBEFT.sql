/****** Object:  Table [dbo].[SUBEFT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBEFT](
	[BorgID] [int] NOT NULL,
	[CredID] [int] NOT NULL,
	[CredHold] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBEFT] ADD  CONSTRAINT [DF_SUBEFT_BorgID]  DEFAULT (1) FOR [BorgID]
ALTER TABLE [dbo].[SUBEFT] ADD  CONSTRAINT [DF_SUBEFT_CredID]  DEFAULT ((-1)) FOR [CredID]
ALTER TABLE [dbo].[SUBEFT] ADD  CONSTRAINT [DF_SUBEFT_CredHold]  DEFAULT (0) FOR [CredHold]