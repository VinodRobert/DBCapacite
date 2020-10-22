/****** Object:  Table [dbo].[MenuTmp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MenuTmp](
	[Lev] [int] NOT NULL,
	[Descr] [nvarchar](30) NOT NULL,
	[Link] [char](55) NOT NULL,
	[isParent] [bit] NOT NULL,
	[ClassName] [char](10) NOT NULL,
	[MenuID] [decimal](23, 0) NOT NULL,
	[Sequence] [decimal](18, 0) NULL
) ON [PRIMARY]