/****** Object:  Table [dbo].[ROLEACCESS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEACCESS](
	[UserID] [char](15) NULL,
	[MenuID] [int] NOT NULL,
	[Enabled] [bit] NOT NULL
) ON [PRIMARY]