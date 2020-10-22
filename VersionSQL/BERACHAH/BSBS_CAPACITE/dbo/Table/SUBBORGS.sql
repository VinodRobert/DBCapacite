/****** Object:  Table [dbo].[SUBBORGS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBBORGS](
	[SUBBORGID] [char](15) NOT NULL,
	[SUBBORGNAME] [char](75) NULL,
	[SUBBORGNAME1] [char](75) NULL,
	[SUBBORGNAME2] [char](75) NULL,
	[PARENTBORGID] [char](15) NOT NULL
) ON [PRIMARY]