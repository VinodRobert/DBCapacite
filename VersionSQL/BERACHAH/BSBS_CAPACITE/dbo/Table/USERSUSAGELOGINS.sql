/****** Object:  Table [dbo].[USERSUSAGELOGINS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[USERSUSAGELOGINS](
	[THEDATE] [datetime] NOT NULL,
	[MAXLOGINCOUNTER] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[USERSUSAGELOGINS] ADD  CONSTRAINT [DF_USERSUSAGELOGINS_THEDATE]  DEFAULT (getdate()) FOR [THEDATE]
ALTER TABLE [dbo].[USERSUSAGELOGINS] ADD  CONSTRAINT [DF_USERSUSAGELOGINS_MAXLOGINCOUNTER]  DEFAULT ((0)) FOR [MAXLOGINCOUNTER]