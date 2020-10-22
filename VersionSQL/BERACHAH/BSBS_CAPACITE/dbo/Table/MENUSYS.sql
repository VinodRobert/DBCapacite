/****** Object:  Table [dbo].[MENUSYS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MENUSYS](
	[Lev] [int] NOT NULL,
	[Descr] [nvarchar](30) NOT NULL,
	[Link] [nvarchar](100) NOT NULL,
	[isParent] [bit] NOT NULL,
	[ClassName] [char](10) NOT NULL,
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[Sequence] [numeric](18, 0) NULL,
	[IsAdmin] [bit] NOT NULL,
	[LongDesc] [char](180) NULL,
	[NewWindow] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[MENUSYS] ADD  CONSTRAINT [DF_MENUSYS_Link]  DEFAULT ('') FOR [Link]
ALTER TABLE [dbo].[MENUSYS] ADD  CONSTRAINT [DF_MENUSYS_NewWindow]  DEFAULT (0) FOR [NewWindow]