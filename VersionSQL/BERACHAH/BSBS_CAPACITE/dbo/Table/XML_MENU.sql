/****** Object:  Table [dbo].[XML_MENU]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[XML_MENU](
	[lev] [int] NOT NULL,
	[menudesc] [nvarchar](100) NOT NULL,
	[link] [nvarchar](100) NOT NULL,
	[isparent] [bit] NOT NULL,
	[classname] [nvarchar](50) NOT NULL,
	[redirect] [nvarchar](50) NOT NULL,
	[info] [nvarchar](250) NOT NULL,
	[info2] [nvarchar](250) NOT NULL,
	[menugroup] [nvarchar](50) NOT NULL,
	[menusequence] [int] NOT NULL,
	[accspec] [int] NOT NULL
) ON [PRIMARY]