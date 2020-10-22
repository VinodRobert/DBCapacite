/****** Object:  Table [dbo].[ROLEDETAILS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEDETAILS](
	[ROLEID] [decimal](18, 0) NOT NULL,
	[ITEMENABLED] [bit] NOT NULL,
	[ITEMPOSITION] [decimal](18, 0) NOT NULL
) ON [PRIMARY]