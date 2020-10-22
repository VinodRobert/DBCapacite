/****** Object:  Table [BT].[BMTUSERPROJECTMAPPING]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BMTUSERPROJECTMAPPING](
	[LOGINID] [varchar](15) NOT NULL,
	[PROJECTID] [int] NOT NULL,
	[ROLEID] [int] NULL
) ON [PRIMARY]