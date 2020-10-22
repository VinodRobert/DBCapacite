/****** Object:  Table [dbo].[TEAMMEMBERS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TEAMMEMBERS](
	[BorgID] [int] NOT NULL,
	[UserID] [char](10) NOT NULL,
	[ContrID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[TEAMMEMBERS] ADD  CONSTRAINT [DF_TEAMMEMBERS_BorgID]  DEFAULT ((-1)) FOR [BorgID]