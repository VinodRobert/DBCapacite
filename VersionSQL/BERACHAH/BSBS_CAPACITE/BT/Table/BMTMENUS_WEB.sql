/****** Object:  Table [BT].[BMTMENUS_WEB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BMTMENUS_WEB](
	[MENUINDEX] [int] NOT NULL,
	[MENULEVEL] [int] NULL,
	[PARENTMENUID] [int] NULL,
	[POSITIONINDEX] [int] NULL,
	[MENUID] [int] NULL,
	[MENUNAME] [varchar](50) NULL,
	[STATUS] [int] NULL,
	[CONTROLLER] [varchar](100) NULL,
	[ACTION] [varchar](100) NULL
) ON [PRIMARY]