/****** Object:  Table [dbo].[CHEQUES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUES](
	[BorgID] [int] NOT NULL,
	[CREDNO] [char](10) NOT NULL,
	[CREDNAME] [char](55) NOT NULL,
	[AMNT] [money] NOT NULL,
	[DISC] [money] NOT NULL
) ON [PRIMARY]