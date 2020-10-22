/****** Object:  Table [dbo].[ROLETEMPLATE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLETEMPLATE](
	[ITEMCATEGORY] [char](55) NULL,
	[ITEMACTION] [char](55) NULL,
	[ITEMLEVELDESC] [char](15) NULL,
	[ITEMDESCRIPTION] [char](255) NULL,
	[ITEMPOSITION] [decimal](18, 0) NOT NULL,
	[LANG] [char](3) NOT NULL
) ON [PRIMARY]