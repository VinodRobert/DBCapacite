/****** Object:  Table [BT].[BMTUSERMENUS_WEB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BMTUSERMENUS_WEB](
	[USERMENUID] [int] IDENTITY(1,1) NOT NULL,
	[LOGINID] [varchar](15) NULL,
	[PROJECTID] [int] NULL,
	[MENUID] [int] NULL,
	[STATUS] [int] NULL,
 CONSTRAINT [PK_BMTUSERMENUS_WEB] PRIMARY KEY CLUSTERED 
(
	[USERMENUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]