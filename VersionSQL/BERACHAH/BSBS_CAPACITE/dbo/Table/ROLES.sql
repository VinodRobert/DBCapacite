/****** Object:  Table [dbo].[ROLES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLES](
	[RoleName] [nvarchar](50) NOT NULL,
	[RoleCategory] [char](25) NULL,
	[Menuid] [int] NOT NULL,
	[IsAllowed] [bit] NOT NULL,
	[TransPerm] [char](1000) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLES] ADD  CONSTRAINT [DF_ROLES_ROLENAME]  DEFAULT ('') FOR [RoleName]
ALTER TABLE [dbo].[ROLES] ADD  CONSTRAINT [DF_ROLES_IsAllowed]  DEFAULT (0) FOR [IsAllowed]
ALTER TABLE [dbo].[ROLES] ADD  CONSTRAINT [DF_ROLES_TransPerm]  DEFAULT ('0|0') FOR [TransPerm]