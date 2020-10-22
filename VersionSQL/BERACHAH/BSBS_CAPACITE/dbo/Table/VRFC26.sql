/****** Object:  Table [dbo].[VRFC26]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VRFC26](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SUPPLIERID] [varchar](10) NULL,
	[SUPPLIERNAME] [varchar](55) NULL,
	[ORGID] [int] NULL,
	[ORGNAME] [varchar](75) NULL,
	[BUCKET0] [money] NULL,
	[BUCKET1] [money] NULL,
	[BUCKET2] [money] NULL,
	[BUCKET3] [money] NULL,
	[BUCKET4] [money] NULL,
	[BUCKET5] [money] NULL,
	[BUCKET6] [money] NULL,
	[BUCKET7] [money] NULL,
	[UNMATCHED] [money] NULL,
	[ORGTOTAL] [money] NULL
) ON [PRIMARY]