/****** Object:  Table [dbo].[SC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SC](
	[CREDNO] [varchar](10) NULL,
	[CREDNAME] [varchar](100) NULL,
	[CONTRACT] [varchar](10) NULL,
	[CONTRACTNAME] [varchar](50) NULL,
	[ADVANCE] [money] NULL,
	[ADVANCEREPAY] [money] NULL,
	[CERTIFIED] [money] NULL,
	[WHT] [money] NULL,
	[RETENTION] [money] NULL,
	[OTHERRETENTION] [money] NULL,
	[ROUNDOFF] [money] NULL,
	[PAID] [money] NULL
) ON [PRIMARY]