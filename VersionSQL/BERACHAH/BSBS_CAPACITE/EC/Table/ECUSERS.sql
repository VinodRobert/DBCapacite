/****** Object:  Table [EC].[ECUSERS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EC].[ECUSERS](
	[BSLOGINID] [varchar](25) NULL,
	[BSUSERNAME] [varchar](100) NULL,
	[BSPASSWORD] [varchar](25) NULL,
	[APPROVERLEVELID] [int] NULL
) ON [PRIMARY]